import 'package:formz/formz.dart';
import 'package:mayflypass/core/core.dart';

sealed class EmailValueError {
  const EmailValueError();

  static String? toHuman(BuildContext context, List<EmailValueError?> errors) {
    if (errors.nonNulls.isEmpty) return null;
    final l10n = AppLocalizations.of(context)!;
    return switch (errors.nonNulls.first) {
      EmailValueRequiredError() => l10n.fieldRequired,
      EmailValueInvalidError() => l10n.emailInvalid,
      EmailValueDuplicatedError() => l10n.accountAlreadyExists,
      EmailValueCredentialsError() => l10n.invalidCrentials,
    };
  }
}

class EmailValueRequiredError extends EmailValueError {
  const EmailValueRequiredError();
}

class EmailValueInvalidError extends EmailValueError {
  const EmailValueInvalidError();
}

class EmailValueDuplicatedError extends EmailValueError {
  const EmailValueDuplicatedError();
}

class EmailValueCredentialsError extends EmailValueError {
  const EmailValueCredentialsError();
}

class EmailValue extends FormzInput<String, EmailValueError> {
  const EmailValue.pure([super.value = '']) : super.pure();
  const EmailValue.dirty([super.value = '']) : super.dirty();

  @override
  EmailValueError? validator(String value) {
    if (value.isEmpty) return const EmailValueRequiredError();
    if (!value.contains('@')) return const EmailValueInvalidError();
    return null;
  }
}
