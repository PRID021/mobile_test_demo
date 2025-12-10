import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_demo/src/core/utils/validator/email_input.dart';
import 'package:mobile_test_demo/src/core/utils/validator/password_input.dart';
import 'package:mobile_test_demo/src/domain/repositories/auth_repository.dart';
import 'package:mobile_test_demo/src/domain/usecases/login_usecase.dart';
import 'package:mobile_test_demo/src/presentation/bloc/login/login_event.dart';
import 'package:mobile_test_demo/src/presentation/bloc/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  late final LoginUseCase loginUseCase;

  LoginBloc({required this.authRepository}) : super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    loginUseCase = LoginUseCase(authRepository);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    final email = EmailInput.dirty(event.value);
    emit(
      state.copyWith(
        email: email,
        status: email.isValid && state.email.isValid
            ? LoginStatus.valid
            : LoginStatus.invalid,
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final password = PasswordInput.dirty(event.value);
    emit(
      state.copyWith(
        password: password,
        status: password.isValid && state.email.isValid
            ? LoginStatus.valid
            : LoginStatus.invalid,
      ),
    );
  }

  void _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isValid) {
      emit(state.copyWith(status: LoginStatus.invalid));
      return;
    }

    emit(state.copyWith(status: LoginStatus.submitting));

    final result = await loginUseCase(
        email: state.email.value, password: state.password.value);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(status: LoginStatus.success),
      ),
    );
  }
}
