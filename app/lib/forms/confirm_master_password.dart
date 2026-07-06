import 'package:formz/formz.dart';
import 'package:mayflypass/core/core.dart';

sealed class ConfirmMasterPasswordValueError {
  const ConfirmMasterPasswordValueError();

  static String? toHuman(
    BuildContext context,
    List<ConfirmMasterPasswordValueError?> errors,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return switch (errors.nonNulls.firstOrNull) {
      ConfirmMasterPasswordValueRequiredError() => l10n.fieldRequired,
      ConfirmMasterPasswordValueMismatchError() => l10n.passwordMismatch,
      null => null,
    };
  }
}

class ConfirmMasterPasswordValueRequiredError
    extends ConfirmMasterPasswordValueError {
  const ConfirmMasterPasswordValueRequiredError();
}

class ConfirmMasterPasswordValueMismatchError
    extends ConfirmMasterPasswordValueError {
  const ConfirmMasterPasswordValueMismatchError();
}

class ConfirmMasterPasswordValue
    extends FormzInput<String, ConfirmMasterPasswordValueError> {
  final String masterPassword;

  const ConfirmMasterPasswordValue.pure(this.masterPassword) : super.pure('');
  const ConfirmMasterPasswordValue.dirty(
    this.masterPassword, {
    String value = '',
  }) : super.dirty(value);

  @override
  ConfirmMasterPasswordValueError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmMasterPasswordValueRequiredError();
    }
    if (value != masterPassword) {
      return ConfirmMasterPasswordValueMismatchError();
    }
    return null;
  }
}
