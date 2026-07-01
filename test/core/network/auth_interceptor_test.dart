import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/network/interceptors/auth_interceptor.dart';

void main() {
  late Dio dio;

  setUp(() {
    dotenv.loadFromString(envString: 'TMDB_ACCESS_TOKEN=test-token-123');
    final interceptor = AuthInterceptor();
    dio = Dio()
      ..interceptors.add(interceptor)
      ..options.baseUrl = 'https://test.com';
  });

  tearDown(() {
    dotenv.clean();
  });

  test('injects Bearer token into request headers', () async {
    RequestOptions? capturedOptions;
    dio.httpClientAdapter = _TestAdapter(
      onRequest: (options) {
        capturedOptions = options;
        return ResponseBody.fromString('{}', 200);
      },
    );

    await dio.get('/test');

    expect(capturedOptions, isNotNull);
    expect(
      capturedOptions!.headers['authorization'],
      equals('Bearer test-token-123'),
    );
  });

  test('does not override existing Authorization header', () async {
    RequestOptions? capturedOptions;
    dio.httpClientAdapter = _TestAdapter(
      onRequest: (options) {
        capturedOptions = options;
        return ResponseBody.fromString('{}', 200);
      },
    );

    await dio.get(
      '/test',
      options: Options(headers: {'Authorization': 'Bearer existing-token'}),
    );

    expect(capturedOptions, isNotNull);
    expect(
      capturedOptions!.headers['authorization'],
      equals('Bearer existing-token'),
    );
  });
}

class _TestAdapter implements HttpClientAdapter {
  _TestAdapter({required this.onRequest});
  final ResponseBody Function(RequestOptions) onRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return onRequest(options);
  }

  @override
  void close({bool force = false}) {}
}
