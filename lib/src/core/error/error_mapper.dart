import 'package:mobile_test_demo/src/core/error/exceptions.dart';
import 'package:mobile_test_demo/src/core/error/failures.dart';

// Đây là file giúp Data → Domain Rx dễ dàng.
class ErrorMapper {
  static Failure toFailure(Exception e) {
    if (e is ServerException) {
      return ServerFailure(e.message);
    } else if (e is NetworkException) {
      return NetworkFailure(e.message);
    } else if (e is CacheException) {
      return CacheFailure(e.message);
    } else if (e is UnauthorizedException) {
      return UnauthorizedFailure(e.message);
    } else {
      return const UnknownFailure('Unexpected error');
    }
  }
}
