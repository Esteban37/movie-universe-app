sealed class Failure {
  Failure({required this.message, this.details});

  final String message;
  final String? details;
}

class NetworkFailure extends Failure {
  NetworkFailure({super.details})
    : super(message: 'No internet connection. Please check your network.');
}

class ServerFailure extends Failure {
  ServerFailure({required this.statusCode, super.details})
    : super(message: 'Server error ($statusCode). Please try again later.');

  final int statusCode;
}

class TimeoutFailure extends Failure {
  TimeoutFailure({super.details})
    : super(message: 'Request timed out. Please try again.');
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure({super.details})
    : super(message: 'Something unexpected happened.');
}
