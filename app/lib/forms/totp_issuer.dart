import 'package:formz/formz.dart';
import 'package:mayflypass/core/core.dart';

sealed class TotpIssuerValueError {
  const TotpIssuerValueError();

  static String? toHuman(
    BuildContext context,
    List<TotpIssuerValueError?> errors,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return switch (errors.nonNulls.firstOrNull) {
      TotpIssuerValueErrorRequiredError() => l10n.fieldRequired,
      null => null,
    };
  }
}

class TotpIssuerValueErrorRequiredError extends TotpIssuerValueError {
  const TotpIssuerValueErrorRequiredError();
}

class TotpIssuerValue extends FormzInput<String, TotpIssuerValueError> {
  const TotpIssuerValue.pure([super.value = '']) : super.pure();
  const TotpIssuerValue.dirty([super.value = '']) : super.dirty();

  @override
  TotpIssuerValueError? validator(String value) {
    if (value.isEmpty) {
      return TotpIssuerValueErrorRequiredError();
    }
    return null;
  }
}
