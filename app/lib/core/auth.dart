import 'dart:io';

import 'package:local_auth/local_auth.dart';
import 'package:mayflypass/core/core.dart';

enum AuthStatus { loading, unauthenticated, unlocked, locked }

class AuthCubit extends Cubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.loading);

  Future<void> checkAuth() async {
    logger.d('check auth');
    final email = await globalStore.getEmail();
    if (email == null) {
      logger.w('email not stored');
      emit(AuthStatus.unauthenticated);
      return;
    }

    // try to get the kek from storage but continue if it's not present

    if (await tryBiometricUnlock()) {
      emit(AuthStatus.unlocked);
      return;
    }

    if (await globalStore.hasSession()) {
      emit(AuthStatus.locked);
    } else {
      await globalStore.flushAll();
      deleteGlobalKek();
      emit(AuthStatus.unauthenticated);
    }
  }

  void unlock() => emit(AuthStatus.unlocked);

  void lock() {
    deleteGlobalKek(); // clean the kek from memory
    emit(AuthStatus.locked);
  }

  void logout() async {
    await globalStore.flushAll();
    deleteGlobalKek(); // clean the kek from memory
    emit(AuthStatus.unauthenticated);
  }

  Future<bool> tryBiometricUnlock() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return false;
    }
    final hasKek = await globalStore.hasKek();
    if (hasKek == false) {
      return false;
    }
    try {
      final LocalAuthentication auth = LocalAuthentication();
      if (await auth.isDeviceSupported() == false) {
        return false;
      }
      if (await auth.authenticate(localizedReason: 'Unlock') == false) {
        return false;
      }
      final kek = await globalStore.getKek();
      if (kek == null) {
        return false;
      }
      setGlobalKek(kek);
      return true;
    } catch (e) {
      logger.e(e);
    }
    return false;
  }
}

final globalAuth = AuthCubit();
