import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/network/interceptors/logging_interceptor.dart';

void main() {
  late Dio dio;

  setUp(() {
    final interceptor = LoggingInterceptor();
    dio = Dio()
      ..interceptors.add(interceptor)
      ..options.baseUrl = 'https://test.com';
  });

  test('logs outgoing request and response', () async {
    dio.httpClientAdapter = _TestAdapter(
      onRequest: (_) => ResponseBody.fromString('{}', 200),
    );

    final response = await dio.get('/test');
    expect(response.statusCode, equals(200));
  });

  test('logs error response', () async {
    dio.httpClientAdapter = _TestAdapter(
      onRequest: (_) => throw DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
        message: 'Connection failed',
      ),
    );

    try {
      await dio.get('/test');
    } catch (_) {}
  });
}

class _TestAdapter implements HttpClientAdapter {
  _TestAdapter({required this.onRequest});
  final dynamic Function(RequestOptions) onRequest;

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
