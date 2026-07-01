import 'package:dio/dio.dart';

import 'failures.dart';

Failure mapDioExceptionToFailure(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return TimeoutFailure(details: exception.message);
    case DioExceptionType.connectionError:
      return NetworkFailure(details: exception.message);
    case DioExceptionType.badResponse:
      final statusCode = exception.response?.statusCode ?? 0;
      if (statusCode >= 500) {
        return ServerFailure(
          statusCode: statusCode,
          details: exception.message,
        );
      }
      return UnexpectedFailure(details: exception.message);
    default:
      return UnexpectedFailure(details: exception.message);
  }
}
