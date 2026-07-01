import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/errors/error_handler.dart';
import 'package:movie_universe_app/core/errors/failures.dart';

void main() {
  group('mapDioExceptionToFailure', () {
    test('maps connection timeout to TimeoutFailure', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final failure = mapDioExceptionToFailure(exception);

      expect(failure, isA<TimeoutFailure>());
    });

    test('maps connection error to NetworkFailure', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      final failure = mapDioExceptionToFailure(exception);

      expect(failure, isA<NetworkFailure>());
    });

    test('maps 5xx response to ServerFailure', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(requestOptions: RequestOptions(path: '/test'), statusCode: 500),
        type: DioExceptionType.badResponse,
      );

      final failure = mapDioExceptionToFailure(exception);

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, equals(500));
    });

    test('maps 4xx response to UnexpectedFailure', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(requestOptions: RequestOptions(path: '/test'), statusCode: 404),
        type: DioExceptionType.badResponse,
      );

      final failure = mapDioExceptionToFailure(exception);

      expect(failure, isA<UnexpectedFailure>());
    });

    test('maps unknown error to UnexpectedFailure', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.unknown,
      );

      final failure = mapDioExceptionToFailure(exception);

      expect(failure, isA<UnexpectedFailure>());
    });
  });
}
