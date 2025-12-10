import 'package:fpdart/fpdart.dart';
import 'package:mobile_test_demo/src/core/error/error_mapper.dart';
import 'package:mobile_test_demo/src/core/error/failures.dart';
import 'package:mobile_test_demo/src/core/storage/token_storage.dart';
import 'package:mobile_test_demo/src/data/datasources/auth_remote_data_source.dart';
import 'package:mobile_test_demo/src/domain/entities/user_credential.dart';
import 'package:mobile_test_demo/src/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.remote, required this.tokenStorage});

  @override
  Future<Either<Failure, UserCredential>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await remote.login(email, password);
      await tokenStorage.saveAccessToken(userCredential.accessToken);
      await tokenStorage.saveRefreshToken(userCredential.refreshToken);
      return Right(userCredential);
    } catch (e) {
      return Left(ErrorMapper.toFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final result = await remote.refreshToken(refreshToken);
      return Right(result);
    } catch (e) {
      tokenStorage.clear();
      return Left(ErrorMapper.toFailure(e as Exception));
    }
  }
}
