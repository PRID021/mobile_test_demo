import 'package:fpdart/fpdart.dart';
import 'package:mobile_test_demo/src/core/error/failures.dart';
import 'package:mobile_test_demo/src/domain/entities/user_credential.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserCredential>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserCredential>> refreshToken({
    required String refreshToken,
  });
}
