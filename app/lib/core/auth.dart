import 'dart:async';
import 'dart:io';
import 'package:local_auth/local_auth.dart';
import 'package:mayflypass/core/core.dart';

enum AuthStatus { loading, unauthenticated, unlocked, locked }

final lockAfterTicker = Stream.periodic(
  Duration(seconds: 5),
  (_) => DateTime.now(),
);

class AuthCubit extends Cubit<AuthStatus> {
  late DateTime _lockAfter;
  late final StreamSubscription<DateTime> _sub;

  AuthCubit() : super(AuthStatus.loading) {
    _lockAfter = DateTime.now().add(Duration(minutes: 1));
    _sub = lockAfterTicker.listen(checkLockTimeout);
  }

  @override
  Future<void> close() {
    _sub.pause();
    _sub.cancel();
    return super.close();
  }

  void checkLockTimeout(DateTime now) {
    switch (state) {
      case .loading:
        return;
      case .unauthenticated:
        return;
      case .locked:
        return;
      default:
      // do nothing
    }
    logger.w('check auth ${_lockAfter.difference(now)}');
    if (now.isAfter(_lockAfter)) {
      lock();
    }
  }

  Future<void> checkAuth() async {
    emit(AuthStatus.loading);

    logger.i('check email is stored');
    final email = await globalStore.getEmail();
    if (email == null) {
      logger.w('email not stored');
      emit(AuthStatus.unauthenticated);
      return;
    }

    logger.i('try biometric unlock');
    if (await tryBiometricUnlock()) {
      emit(AuthStatus.unlocked);
      return;
    }

    logger.i('check is a session is setup');
    if (await globalStore.hasSession()) {
      lock();
    } else {
      await logout();
    }
  }

  Future<void> unlocked() async {
    final afterDuration = await globalStore.getSettingsLockAfterDuration();
    _lockAfter = DateTime.now().add(afterDuration);
    emit(AuthStatus.unlocked);
  }

  Future<void> refreshLockAfter() async {
    final afterDuration = await globalStore.getSettingsLockAfterDuration();
    _lockAfter = DateTime.now().add(afterDuration);
  }

  void lock() {
    deleteGlobalKek(); // clean the kek from memory
    emit(AuthStatus.locked);
  }

  Future<void> logout() async {
    emit(AuthStatus.loading);
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
