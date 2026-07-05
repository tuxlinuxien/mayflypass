import 'package:formz/formz.dart';
import 'package:mayflypass/core/core.dart';

sealed class MasterPasswordValueError {
  const MasterPasswordValueError();

  static String? toHuman(
    BuildContext context,
    List<MasterPasswordValueError?> errors,
  ) {
    if (errors.nonNulls.isEmpty) return null;
    final l10n = AppLocalizations.of(context)!;
    return switch (errors.nonNulls.first) {
      MasterPasswordValueRequiredError() => l10n.fieldRequired,
      MasterPasswordValueMinError(:final min) => l10n.passwordTooShort(min),
    };
  }
}

class MasterPasswordValueRequiredError extends MasterPasswordValueError {
  const MasterPasswordValueRequiredError();
}

class MasterPasswordValueMinError extends MasterPasswordValueError {
  final int min;
  const MasterPasswordValueMinError(this.min);
}

class MasterPasswordValue extends FormzInput<String, MasterPasswordValueError> {
  const MasterPasswordValue.pure([super.value = '']) : super.pure();
  const MasterPasswordValue.dirty([super.value = '']) : super.dirty();

  static const int minLength = 8;

  @override
  MasterPasswordValueError? validator(String value) {
    if (value.isEmpty) return const MasterPasswordValueRequiredError();
    if (value.length < minLength) {
      return const MasterPasswordValueMinError(minLength);
    }
    return null;
  }
}
