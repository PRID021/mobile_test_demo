import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid }

class EmailInput extends FormzInput<String, EmailValidationError> {
  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty([super.value = '']) : super.dirty();

  /// Convert error enum → readable message
  String? get errorMessage {
    switch (error) {
      case EmailValidationError.empty:
        return 'Email không được bỏ trống';
      case EmailValidationError.invalid:
        return 'Email không hợp lệ';
      default:
        return null;
    }
  }

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }

    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return emailRegex.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}
