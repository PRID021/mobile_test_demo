import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_test_demo/src/core/error/failures.dart';
import 'package:mobile_test_demo/src/domain/entities/user_credential.dart';
import 'package:mobile_test_demo/src/domain/repositories/auth_repository.dart';
import 'package:mobile_test_demo/src/domain/usecases/refresh_token_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RefreshTokenUseCase refreshTokenUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    refreshTokenUseCase = RefreshTokenUseCase(mockAuthRepository);
  });

  const tRefreshToken = 'test_refresh_token';
  final tUserCredential = UserCredential(
    accessToken: 'new_access_token',
    refreshToken: tRefreshToken,
  );
  final tServerFailure = ServerFailure('Server Error');

  group('RefreshTokenUseCase', () {
    test(
        'should get new user credential from the repository when refresh token is successful',
        () async {
      // Arrange
      when(() => mockAuthRepository.refreshToken(refreshToken: tRefreshToken))
          .thenAnswer((_) async => Right(tUserCredential));

      // Act
      final result = await refreshTokenUseCase(tRefreshToken);

      // Assert
      expect(result, Right(tUserCredential));
      verify(() => mockAuthRepository.refreshToken(refreshToken: tRefreshToken))
          .called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test(
        'should return a failure from the repository when refresh token is unsuccessful',
        () async {
      // Arrange
      when(() => mockAuthRepository.refreshToken(refreshToken: tRefreshToken))
          .thenAnswer((_) async => Left(tServerFailure));

      // Act
      final result = await refreshTokenUseCase(tRefreshToken);

      // Assert
      expect(result, Left(tServerFailure));
      verify(() => mockAuthRepository.refreshToken(refreshToken: tRefreshToken))
          .called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
