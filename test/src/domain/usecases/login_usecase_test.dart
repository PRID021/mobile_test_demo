import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_test_demo/src/core/error/failures.dart';
import 'package:mobile_test_demo/src/domain/entities/user_credential.dart';
import 'package:mobile_test_demo/src/domain/repositories/auth_repository.dart';
import 'package:mobile_test_demo/src/domain/usecases/login_usecase.dart';

// 1. Create a mock for the dependency
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  // 2. Declare the variables needed for the tests
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  // 3. Set up the test environment
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  // Dummy data for testing
  const tEmail = 'test@email.com';
  const tPassword = 'password';
  final tUserCredential = UserCredential(
    accessToken: 'test_access_token',
    refreshToken: 'test_refresh_token',
  );
  final tServerFailure = ServerFailure('Server Error');

  group('LoginUseCase', () {
    test(
        'should get user credential from the repository when login is successful',
        () async {
      // Arrange: Stub the repository method to return a successful result
      when(() => mockAuthRepository.login(email: tEmail, password: tPassword))
          .thenAnswer((_) async => Right(tUserCredential));

      // Act: Call the use case
      final result = await loginUseCase(email: tEmail, password: tPassword);

      // Assert: Check if the result is what we expect
      expect(result, Right(tUserCredential));
      // Verify that the login method on the repository was called once
      verify(() => mockAuthRepository.login(email: tEmail, password: tPassword))
          .called(1);
      // Ensure no other methods were called on the mock
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test(
        'should return a failure from the repository when login is unsuccessful',
        () async {
      // Arrange: Stub the repository method to return a failure
      when(() => mockAuthRepository.login(email: tEmail, password: tPassword))
          .thenAnswer((_) async => Left(tServerFailure));

      // Act: Call the use case
      final result = await loginUseCase(email: tEmail, password: tPassword);

      // Assert: Check if the result is a failure
      expect(result, Left(tServerFailure));
      // Verify that the login method on the repository was called once
      verify(() => mockAuthRepository.login(email: tEmail, password: tPassword))
          .called(1);
      // Ensure no other methods were called on the mock
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
