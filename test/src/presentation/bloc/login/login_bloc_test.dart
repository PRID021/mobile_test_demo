import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_test_demo/src/core/error/failures.dart';
import 'package:mobile_test_demo/src/domain/entities/user_credential.dart';
import 'package:mobile_test_demo/src/domain/repositories/auth_repository.dart';
import 'package:mobile_test_demo/src/presentation/bloc/login/login_bloc.dart';
import 'package:mobile_test_demo/src/presentation/bloc/login/login_event.dart';
import 'package:mobile_test_demo/src/presentation/bloc/login/login_state.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginBloc loginBloc;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginBloc = LoginBloc(authRepository: mockAuthRepository);
  });

  tearDown(() {
    loginBloc.close();
  });

  const tEmail = 'test@example.com';
  const tPassword = 'Password123';
  const tUserCredential = UserCredential(
    accessToken: 'test_access_token',
    refreshToken: 'test_refresh_token',
  );
  const tServerFailure = ServerFailure('Server Error');

  group('LoginBloc', () {
    test('initial state is LoginState()', () {
      expect(loginBloc.state, const LoginState());
    });

    group('LoginSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'emits [submitting, success] when login is successful',
        setUp: () {
          when(() =>
                  mockAuthRepository.login(email: tEmail, password: tPassword))
              .thenAnswer((_) async => const Right(tUserCredential));
        },
        build: () => loginBloc,
        act: (bloc) {
          bloc
            ..add(EmailChanged(tEmail))
            ..add(PasswordChanged(tPassword))
            ..add(LoginSubmitted());
        },
        expect: () => [
          isA<LoginState>()
              .having((s) => s.email.value, 'email', tEmail)
              .having((s) => s.status, 'status', LoginStatus.invalid),
          isA<LoginState>()
              .having((s) => s.password.value, 'password', tPassword)
              .having((s) => s.status, 'status', LoginStatus.valid),
          isA<LoginState>()
              .having((s) => s.status, 'status', LoginStatus.submitting),
          isA<LoginState>()
              .having((s) => s.status, 'status', LoginStatus.success),
        ],
        verify: (_) {
          verify(() =>
                  mockAuthRepository.login(email: tEmail, password: tPassword))
              .called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submitting, failure] when login is unsuccessful',
        setUp: () {
          when(() =>
                  mockAuthRepository.login(email: tEmail, password: tPassword))
              .thenAnswer((_) async => const Left(tServerFailure));
        },
        build: () => loginBloc,
        act: (bloc) {
          bloc
            ..add(EmailChanged(tEmail))
            ..add(PasswordChanged(tPassword))
            ..add(LoginSubmitted());
        },
        expect: () => [
          isA<LoginState>()
              .having((s) => s.email.value, 'email', tEmail)
              .having((s) => s.status, 'status', LoginStatus.invalid),
          isA<LoginState>()
              .having((s) => s.password.value, 'password', tPassword)
              .having((s) => s.status, 'status', LoginStatus.valid),
          isA<LoginState>()
              .having((s) => s.status, 'status', LoginStatus.submitting),
          isA<LoginState>()
              .having((s) => s.status, 'status', LoginStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage',
                  tServerFailure.message),
        ],
        verify: (_) {
          verify(() =>
                  mockAuthRepository.login(email: tEmail, password: tPassword))
              .called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [invalid] when submitting with invalid form',
        build: () => loginBloc,
        act: (bloc) => bloc.add(LoginSubmitted()),
        expect: () => [
          isA<LoginState>()
              .having((s) => s.status, 'status', LoginStatus.invalid),
        ],
        verify: (_) {
          verifyNever(() => mockAuthRepository.login(
              email: any(named: 'email'), password: any(named: 'password')));
        },
      );
    });
  });
}
