import 'package:formz/formz.dart';
import 'package:mayflypass/core/core.dart';

sealed class TotpAccountValueError {
  const TotpAccountValueError();

  static String? toHuman(
    BuildContext context,
    List<TotpAccountValueError?> errors,
  ) {
    return null;
  }
}

class TotpAccountValue extends FormzInput<String, TotpAccountValueError> {
  const TotpAccountValue.pure([super.value = '']) : super.pure();
  const TotpAccountValue.dirty([super.value = '']) : super.dirty();

  @override
  TotpAccountValueError? validator(String value) {
    return null;
  }
}
