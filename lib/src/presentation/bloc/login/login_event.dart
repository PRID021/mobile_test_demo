
abstract class LoginEvent {}

class EmailChanged extends LoginEvent {
  final String value;
  EmailChanged(this.value);
}

class PasswordChanged extends LoginEvent {
  final String value;
  PasswordChanged(this.value);
}

class LoginSubmitted extends LoginEvent {}
