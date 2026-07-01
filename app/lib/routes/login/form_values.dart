import 'package:formz/formz.dart';

sealed class EmailError {
  const EmailError();
}

class EmailInvalidCredentialsError extends EmailError {
  const EmailInvalidCredentialsError();
}

class EmailInvalidError extends EmailError {
  const EmailInvalidError();
}

class EmailRequiredError extends EmailError {
  const EmailRequiredError();
}

class Email extends FormzInput<String, EmailError> {
  const Email.pure([super.value = '']) : super.pure();
  const Email.dirty([super.value = '']) : super.dirty();

  @override
  EmailError? validator(String value) {
    if (value.isEmpty) return const EmailRequiredError();
    return null;
  }
}

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
    if (value.isEmpty) return const MasterPasswordRequiredError();
    return null;
  }
}
