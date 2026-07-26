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
      TotpIssuerValueErrorTooLongError(:final max) => l10n.totpIssuerTooLong(
        max,
      ),
      null => null,
    };
  }
}

class TotpIssuerValueErrorRequiredError extends TotpIssuerValueError {
  const TotpIssuerValueErrorRequiredError();
}

class TotpIssuerValueErrorTooLongError extends TotpIssuerValueError {
  final int max;
  const TotpIssuerValueErrorTooLongError(this.max);
}

class TotpIssuerValue extends FormzInput<String, TotpIssuerValueError> {
  const TotpIssuerValue.pure([super.value = '']) : super.pure();
  const TotpIssuerValue.dirty([super.value = '']) : super.dirty();

  @override
  TotpIssuerValueError? validator(String value) {
    if (value.isEmpty) {
      return TotpIssuerValueErrorRequiredError();
    }
    if (value.length > 64) {
      return const TotpIssuerValueErrorTooLongError(64);
    }
    return null;
  }
}
