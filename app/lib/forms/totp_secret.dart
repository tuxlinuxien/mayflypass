import 'package:formz/formz.dart';
import 'package:mayflypass/core/core.dart';

sealed class TotpSecretValueError {
  const TotpSecretValueError();

  static String? toHuman(
    BuildContext context,
    List<TotpSecretValueError?> errors,
  ) {
    return null;
  }
}

class TotpSecretValueErrorMin extends TotpSecretValueError {
  final int min;

  const TotpSecretValueErrorMin(this.min);
}

class TotpSecretValue extends FormzInput<String, TotpSecretValueError> {
  const TotpSecretValue.pure([super.value = '']) : super.pure();
  const TotpSecretValue.dirty([super.value = '']) : super.dirty();

  @override
  TotpSecretValueError? validator(String value) {
    if (value.trim().length < 16) {
      return TotpSecretValueErrorMin(16);
    }
    return null;
  }
}
