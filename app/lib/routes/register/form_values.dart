import 'package:formz/formz.dart';

sealed class EmailError {
  const EmailError();
}

class EmailRequiredError extends EmailError {
  const EmailRequiredError();
}

class EmailInvalidError extends EmailError {
  const EmailInvalidError();
}

class EmailDuplicatedError extends EmailError {
  const EmailDuplicatedError();
}

class Email extends FormzInput<String, EmailError> {
  const Email.pure([super.value = '']) : super.pure();
  const Email.dirty([super.value = '']) : super.dirty();

  @override
  EmailError? validator(String value) {
    if (value.isEmpty) return const EmailRequiredError();
    if (!value.contains('@')) return const EmailInvalidError();
    return null;
  }
}

sealed class MasterPasswordError {
  const MasterPasswordError();
}

class MasterPasswordRequiredError extends MasterPasswordError {
  const MasterPasswordRequiredError();
}

class MasterPasswordMinError extends MasterPasswordError {
  final int min;
  const MasterPasswordMinError(this.min);
}

class MasterPassword extends FormzInput<String, MasterPasswordError> {
  const MasterPassword.pure([super.value = '']) : super.pure();
  const MasterPassword.dirty([super.value = '']) : super.dirty();

  static const int minLength = 8;

  @override
  MasterPasswordError? validator(String value) {
    if (value.isEmpty) return const MasterPasswordRequiredError();
    if (value.length < minLength) {
      return const MasterPasswordMinError(minLength);
    }
    return null;
  }
}

sealed class ConfirmMasterPasswordError {
  const ConfirmMasterPasswordError();
}

class ConfirmMasterPasswordRequiredError extends ConfirmMasterPasswordError {
  const ConfirmMasterPasswordRequiredError();
}

class ConfirmMasterPasswordMismatchError extends ConfirmMasterPasswordError {
  const ConfirmMasterPasswordMismatchError();
}

class ConfirmMasterPassword
    extends FormzInput<String, ConfirmMasterPasswordError> {
  final String masterPassword;

  const ConfirmMasterPassword.pure(this.masterPassword) : super.pure('');
  const ConfirmMasterPassword.dirty(this.masterPassword, {String value = ''})
    : super.dirty(value);

  @override
  ConfirmMasterPasswordError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmMasterPasswordRequiredError();
    }
    if (value != masterPassword) {
      return ConfirmMasterPasswordMismatchError();
    }
    return null;
  }
}
