// các Exception từ tầng Data

class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({required this.message, this.statusCode});

  @override
  String toString() => 'AppException: $message (code: $statusCode)';
}

class ServerException extends AppException {
  ServerException({required super.message, super.statusCode});
}

class UnauthorizedException extends AppException {
  UnauthorizedException({super.message = 'Unauthorized'})
      : super(statusCode: 401);
}

class NetworkException extends AppException {
  NetworkException({super.message = 'Network Error'});
}

class CacheException extends AppException {
  CacheException({super.message = 'Cache Error'});
}

class UnknownException extends AppException {
  UnknownException({super.message = 'Unknown Error'});
}
