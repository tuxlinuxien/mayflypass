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
      UsernameValueTooLongError(:final max) => l10n.usernameTooLong(max),
      UsernameValueTooShortError(:final min) => l10n.usernameTooShort(min),
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

class UsernameValueTooShortError extends UsernameValueError {
  final int min;
  const UsernameValueTooShortError(this.min);
}

class UsernameValueTooLongError extends UsernameValueError {
  final int max;
  const UsernameValueTooLongError(this.max);
}

class UsernameValue extends FormzInput<String, UsernameValueError> {
  const UsernameValue.pure([super.value = '']) : super.pure();
  const UsernameValue.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValueError? validator(String value) {
    if (value.isEmpty) return const UsernameValueRequiredError();
    if (value.length < 5) return const UsernameValueTooShortError(5);
    if (value.length > 50) return const UsernameValueTooLongError(50);
    if (!RegExp(r'^[a-z0-9]+$').hasMatch(value.trim().toLowerCase())) {
      return const UsernameValueInvalidError();
    }
    return null;
  }
}
