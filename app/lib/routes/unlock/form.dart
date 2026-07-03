import 'package:formz/formz.dart';

sealed class MasterPasswordError {
  const MasterPasswordError();
}

class MasterPasswordRequiredError extends MasterPasswordError {
  const MasterPasswordRequiredError();
}

class MasterPassword extends FormzInput<String, MasterPasswordError> {
  const MasterPassword.pure([super.value = '']) : super.pure();
  const MasterPassword.dirty([super.value = '']) : super.dirty();

  @override
  MasterPasswordError? validator(String value) {
    if (value.isEmpty) {
      return MasterPasswordRequiredError();
    }
    return null;
  }
}
