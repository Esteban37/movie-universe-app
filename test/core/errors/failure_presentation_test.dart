import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/errors/failure_presentation.dart';
import 'package:movie_universe_app/core/errors/failures.dart';

void main() {
  group('failureUserMessage', () {
    test('returns friendly message for NetworkFailure', () {
      final failure = NetworkFailure();
      expect(
        failureUserMessage(failure),
        'No internet connection. Please check your network.',
      );
      expect(failureUserMessage(failure), isNot(contains('Instance of')));
    });

    test('returns friendly message for ServerFailure', () {
      final failure = ServerFailure(statusCode: 503);
      expect(failureUserMessage(failure), contains('503'));
      expect(failureUserMessage(failure), isNot(contains('Instance of')));
    });

    test('returns friendly message for TimeoutFailure', () {
      final failure = TimeoutFailure();
      expect(failureUserMessage(failure), contains('timed out'));
    });

    test('returns friendly message for UnexpectedFailure', () {
      final failure = UnexpectedFailure();
      expect(failureUserMessage(failure), contains('unexpected'));
    });
  });

  group('errorDisplayMessage', () {
    test('uses failure message for typed failures', () {
      expect(
        errorDisplayMessage(NetworkFailure()),
        'No internet connection. Please check your network.',
      );
    });

    test('falls back to generic message for non-failure errors', () {
      expect(
        errorDisplayMessage(Exception('boom')),
        'Something unexpected happened.',
      );
    });
  });
}
