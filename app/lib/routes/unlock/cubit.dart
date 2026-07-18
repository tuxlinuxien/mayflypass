import 'dart:io';

import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:formz/formz.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/forms/master_password.dart';
import 'package:mayflypass/secure/secure.dart';

part 'cubit.freezed.dart';

enum FormStatus { initial, submitting, success, failure }

@freezed
abstract class UnlockFormState with _$UnlockFormState {
  const factory UnlockFormState({
    @Default('') String username,
    @Default(false) bool biometricUnlock,
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
    final username = await globalStore.getUsername();
    if (username == null) {
      return;
    }
    var biometricUnlockAvailable = false;
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        final LocalAuthentication auth = LocalAuthentication();
        biometricUnlockAvailable = await auth.isDeviceSupported();
      } catch (e) {
        logger.e(e);
        biometricUnlockAvailable = false;
      }
    }
    var hasKek = await globalStore.hasKek();
    emit(
      state.copyWith(
        status: .initial,
        username: username,
        biometricUnlock: biometricUnlockAvailable && hasKek,
      ),
    );
  }

  void unlock() async {
    final isValid = Formz.validate([state.masterPassword]);
    if (!isValid) return;

    emit(state.copyWith(status: .submitting));

    final username = await globalStore.getUsername();
    if (username == null) {
      globalAuth.logout();
      return;
    }

    final password = state.masterPassword.value;
    final masterKey = await deriveMasterPassword(username, password);
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

  Future<void> biometricUnlock() async {
    if (await globalAuth.tryBiometricUnlock() == true) {
      globalAuth.unlocked();
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
