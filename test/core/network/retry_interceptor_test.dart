import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/network/interceptors/retry_interceptor.dart';

void main() {
  late Dio dio;

  setUp(() {
    dio = Dio()..options.baseUrl = 'https://test.com';
    final interceptor = RetryInterceptor(
      maxRetries: 3,
      baseDelay: Duration.zero,
      dio: dio,
    );
    dio.interceptors.add(interceptor);
  });

  test('retries on connection error', () async {
    var attemptCount = 0;
    dio.httpClientAdapter = _TestAdapter(
      onRequest: (_) {
        attemptCount++;
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionError,
        );
      },
    );

    try {
      await dio.get('/test');
    } catch (_) {}

    expect(attemptCount, equals(4));
  });

  test('does not retry on 4xx errors', () async {
    var attemptCount = 0;
    dio.httpClientAdapter = _TestAdapter(
      onRequest: (_) {
        attemptCount++;
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(requestOptions: RequestOptions(path: '/test'), statusCode: 404),
          type: DioExceptionType.badResponse,
        );
      },
    );

    try {
      await dio.get('/test');
    } catch (_) {}

    expect(attemptCount, equals(1));
  });

  test('succeeds on retry after transient failure', () async {
    var attemptCount = 0;
    dio.httpClientAdapter = _TestAdapter(
      onRequest: (_) {
        attemptCount++;
        if (attemptCount == 1) {
          throw DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionError,
          );
        }
        return ResponseBody.fromString('{}', 200);
      },
    );

    final response = await dio.get('/test');

    expect(response.statusCode, equals(200));
    expect(attemptCount, equals(2));
  });
}

class _TestAdapter implements HttpClientAdapter {
  final dynamic Function(RequestOptions) onRequest;

  _TestAdapter({required this.onRequest});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final result = onRequest(options);
    if (result is ResponseBody) return result;
    throw result;
  }

  @override
  void close({bool force = false}) {}
}
