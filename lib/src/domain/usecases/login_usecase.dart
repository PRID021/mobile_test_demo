import 'package:fpdart/fpdart.dart';
import 'package:mobile_test_demo/src/core/error/failures.dart';
import 'package:mobile_test_demo/src/domain/entities/user_credential.dart';
import 'package:mobile_test_demo/src/domain/repositories/auth_repository.dart';

// UseCase tách rõ business logic
// BLoC sử dụng usecase.call() thay vì repo
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserCredential>> call({
    required String email,
    required String password,
  }) {
    return repository.login(
      email: email,
      password: password,
    );
  }
}
