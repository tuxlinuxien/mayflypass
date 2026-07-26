import 'package:formz/formz.dart';
import 'package:mayflypass/core/core.dart';

sealed class TotpAccountValueError {
  const TotpAccountValueError();

  static String? toHuman(
    BuildContext context,
    List<TotpAccountValueError?> errors,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return switch (errors.nonNulls.firstOrNull) {
      TotpAccountValueTooLongError(:final max) => l10n.totpAccountTooLong(max),
      null => null,
    };
  }
}

class TotpAccountValueTooLongError extends TotpAccountValueError {
  final int max;
  const TotpAccountValueTooLongError(this.max);
}

class TotpAccountValue extends FormzInput<String, TotpAccountValueError> {
  const TotpAccountValue.pure([super.value = '']) : super.pure();
  const TotpAccountValue.dirty([super.value = '']) : super.dirty();

  @override
  TotpAccountValueError? validator(String value) {
    if (value.length > 64) {
      return const TotpAccountValueTooLongError(64);
    }
    return null;
  }
}
