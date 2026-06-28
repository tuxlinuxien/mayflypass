import 'package:formz/formz.dart';
import 'package:mayflypass/helpers/errors.dart';

class Email extends FormzInput<String, ValueError> {
  const Email.pure([super.value = '']) : super.pure();
  const Email.dirty([super.value = '']) : super.dirty();

  @override
  ValueError? validator(String value) {
    if (value.isEmpty) return const ValueRequiredError();
    if (!value.contains('@')) return const EmailInvalidError();
    return null;
  }
}

class MasterPassword extends FormzInput<String, ValueError> {
  const MasterPassword.pure([super.value = '']) : super.pure();
  const MasterPassword.dirty([super.value = '']) : super.dirty();

  static const int minLength = 8;

  @override
  ValueError? validator(String value) {
    if (value.isEmpty) return const ValueRequiredError();
    if (value.length < minLength) {
      return ValueTooShortError(minLength);
    }
    return null;
  }
}

class ConfirmMasterPassword extends FormzInput<String, ValueError> {
  final String masterPassword;

  const ConfirmMasterPassword.pure(this.masterPassword) : super.pure('');

  const ConfirmMasterPassword.dirty(this.masterPassword, {String value = ''})
    : super.dirty(value);

  @override
  ValueError? validator(String value) {
    if (value.isEmpty) return ValueRequiredError(); // or required error
    if (value != masterPassword) return ValueMismatchError();
    return null;
  }
}

class RegisterForm with FormzMixin {
  final Email email;
  final MasterPassword masterPassword;
  final ConfirmMasterPassword confirmMasterPassword;

  RegisterForm({
    Email? email,
    MasterPassword? masterPassword,
    ConfirmMasterPassword? confirmMasterPassword,
  }) : email = email ?? const Email.pure(),
       masterPassword = masterPassword ?? const MasterPassword.pure(),
       confirmMasterPassword =
           confirmMasterPassword ??
           ConfirmMasterPassword.pure(masterPassword?.value ?? '');

  RegisterForm copyWith({
    Email? email,
    MasterPassword? masterPassword,
    ConfirmMasterPassword? confirmMasterPassword,
  }) {
    return RegisterForm(
      email: email ?? this.email,
      masterPassword: masterPassword ?? this.masterPassword,
      confirmMasterPassword:
          confirmMasterPassword ?? this.confirmMasterPassword,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [
    email,
    masterPassword,
    confirmMasterPassword,
  ];
}
