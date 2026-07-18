import 'package:formz/formz.dart';
import 'package:mayflypass/core/core.dart';

sealed class UsernameValueError {
  const UsernameValueError();

  static String? toHuman(
    BuildContext context,
    List<UsernameValueError?> errors,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return switch (errors.nonNulls.firstOrNull) {
      UsernameValueRequiredError() => l10n.fieldRequired,
      UsernameValueInvalidError() => l10n.usernameInvalid,
      UsernameValueDuplicatedError() => l10n.accountAlreadyExists,
      UsernameValueCredentialsError() => l10n.invalidCredentials,
      null => null,
    };
  }
}

class UsernameValueRequiredError extends UsernameValueError {
  const UsernameValueRequiredError();
}

class UsernameValueInvalidError extends UsernameValueError {
  const UsernameValueInvalidError();
}

class UsernameValueDuplicatedError extends UsernameValueError {
  const UsernameValueDuplicatedError();
}

class UsernameValueCredentialsError extends UsernameValueError {
  const UsernameValueCredentialsError();
}

class UsernameValue extends FormzInput<String, UsernameValueError> {
  const UsernameValue.pure([super.value = '']) : super.pure();
  const UsernameValue.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValueError? validator(String value) {
    if (value.isEmpty) return const UsernameValueRequiredError();
    if (!value.contains('@')) return const UsernameValueInvalidError();
    return null;
  }
}
