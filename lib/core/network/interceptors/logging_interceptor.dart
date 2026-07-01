import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method;
    final url = options.uri.toString();
    print('[HTTP] --> $method $url');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final method = response.requestOptions.method;
    final url = response.requestOptions.uri.toString();
    final statusCode = response.statusCode;
    print('[HTTP] <-- $method $url ($statusCode)');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final method = err.requestOptions.method;
    final url = err.requestOptions.uri.toString();
    final statusCode = err.response?.statusCode;
    print('[HTTP] <-- $method $url ($statusCode) ERROR: ${err.message}');
    handler.next(err);
  }
}
