import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:mobile_test_demo/src/core/utils/validator/email_input.dart';
import 'package:mobile_test_demo/src/core/utils/validator/password_input.dart';

enum LoginStatus {
  pure,
  valid,
  invalid,
  submitting,
  success,
  failure,
}

class LoginState extends Equatable {
  final EmailInput email;
  final PasswordInput password;
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.status = LoginStatus.pure,
    this.errorMessage,
  });

  LoginState copyWith({
    EmailInput? email,
    PasswordInput? password,
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, status, errorMessage];

  bool get isValid => Formz.validate([email, password]);
}
