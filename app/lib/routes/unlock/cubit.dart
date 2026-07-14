import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:formz/formz.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/forms/master_password.dart';
import 'package:mayflypass/secure/secure.dart';

part 'cubit.freezed.dart';

enum FormStatus { initial, submitting, success, failure }

@freezed
abstract class UnlockFormState with _$UnlockFormState {
  const factory UnlockFormState({
    @Default('') String email,
    @Default(false) bool withBiometricUnlock,
    @Default(MasterPasswordValue.pure()) MasterPasswordValue masterPassword,
    @Default(FormStatus.initial) FormStatus status,
  }) = _UnlockFormState;
}

class FormCubit extends Cubit<UnlockFormState> {
  FormCubit() : super(UnlockFormState());

  void masterPasswordChanged(String value) {
    emit(
      state.copyWith(
        status: .initial,
        masterPassword: MasterPasswordValue.dirty(value),
      ),
    );
  }

  void load() async {
    final email = await globalStore.getEmail();
    if (email == null) {
      return;
    }
    emit(state.copyWith(status: .initial, email: email));
  }

  void unlock() async {
    final isValid = Formz.validate([state.masterPassword]);
    if (!isValid) return;

    emit(state.copyWith(status: .submitting));

    final email = await globalStore.getEmail();
    if (email == null) {
      globalAuth.logout();
      return;
    }

    final password = state.masterPassword.value;
    final masterKey = await deriveMasterPassword(email, password);
    final sessionKey = await deriveSessionKey(masterKey);
    final kek = await deriveKek(masterKey);

    // delete masterKey because it's not used anymore.
    masterKey.destroy();

    final ok = await globalStore.unlockSession(sessionKey);
    // already used delete it now as well.
    sessionKey.destroy();
    switch (ok) {
      case true:
        setGlobalKek(kek);
        emit(state.copyWith(status: .success));
      case false:
        emit(state.copyWith(status: .failure));
      case null:
        globalAuth.logout();
    }
  }
}

Future<bool> compareUnlockKeys(
  List<int> unlockKeyBytes,
  SecretKey unlockKey,
) async {
  final bytes = await unlockKey.extractBytes();
  if (bytes.length != unlockKeyBytes.length) return false;

  var r = 0;
  for (int i = 0; i < bytes.length; i++) {
    r |= bytes[i] ^ unlockKeyBytes[i];
  }
  return r == 0;
}
