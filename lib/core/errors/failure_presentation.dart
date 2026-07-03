import 'failures.dart';

/// Maps a typed [Failure] to its user-facing message via exhaustive matching.
String failureUserMessage(Failure failure) {
  return switch (failure) {
    NetworkFailure() => failure.message,
    ServerFailure() => failure.message,
    TimeoutFailure() => failure.message,
    UnexpectedFailure() => failure.message,
  };
}

/// Resolves a display message from any async error, preferring typed failures.
String errorDisplayMessage(Object error) {
  if (error is Failure) {
    return failureUserMessage(error);
  }
  return UnexpectedFailure().message;
}
