import 'package:formz/formz.dart';

enum PasswordValidationError { empty }

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  /// Convert error enum → readable message
  String? get errorMessage {
    switch (error) {
      case PasswordValidationError.empty:
        return 'Password không được bỏ trống';
      default:
        return null;
    }
  }

  @override
  PasswordValidationError? validator(String value) {
    return value.isNotEmpty ? null : PasswordValidationError.empty;
  }
}
