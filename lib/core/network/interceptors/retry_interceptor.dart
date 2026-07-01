import 'dart:async';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
    Dio? dio,
  }) : _sourceDio = dio;

  final int maxRetries;
  final Duration baseDelay;
  final Dio? _sourceDio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _retry(err, handler, 0);
  }

  void _retry(
    DioException err,
    ErrorInterceptorHandler handler,
    int attempt,
  ) {
    if (!_shouldRetry(err) || attempt >= maxRetries) {
      handler.next(err);
      return;
    }

    final delay = baseDelay * (1 << attempt);

    Timer(delay, () async {
      try {
        final dio = _buildRetryDio();
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        _retry(e as DioException, handler, attempt + 1);
      }
    });
  }

  Dio _buildRetryDio() {
    final source = _sourceDio;
    if (source == null) return Dio();
    final dio = Dio(source.options)
      ..httpClientAdapter = source.httpClientAdapter;
    for (final interceptor in source.interceptors) {
      if (interceptor != this) {
        dio.interceptors.add(interceptor);
      }
    }
    return dio;
  }

  bool _shouldRetry(DioException err) {
    if (err.requestOptions.method != 'GET') return false;
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }
    if (err.response != null && err.response!.statusCode! >= 500) {
      return true;
    }
    return false;
  }
}
