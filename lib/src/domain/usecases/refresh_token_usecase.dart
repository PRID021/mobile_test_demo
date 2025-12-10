import 'package:fpdart/fpdart.dart';
import 'package:mobile_test_demo/src/core/error/failures.dart';
import 'package:mobile_test_demo/src/domain/entities/user_credential.dart';
import 'package:mobile_test_demo/src/domain/repositories/auth_repository.dart';

// Giúp App xử lý tự động khi Interceptor refresh token
// Giảm logic trong Repository và UI
class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Either<Failure, UserCredential>> call(String refreshToken) {
    return repository.refreshToken(refreshToken: refreshToken);
  }
}
