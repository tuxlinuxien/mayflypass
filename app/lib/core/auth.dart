import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayflypass/core/core.dart';

enum AuthStatus { loading, unauthenticated, unlocked, locked }

class AuthCubit extends Cubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.loading) {
    // always delete the kek when the app boots.
    deleteGlobalKek();
  }

  Future<void> checkAuth() async {
    final email = await globalStore.getEmail();
    if (email == null) {
      emit(AuthStatus.unauthenticated);
      return;
    }
    // try to get the kek from storage but continue if it's not present
    final kek = await globalStore.getKek();
    if (kek != null) {
      setGlobalKek(kek);
      emit(AuthStatus.unlocked);
      return;
    }
    final unlockKeyBytes = await globalStore.getUnlockKey();
    if (unlockKeyBytes == null) {
      await globalStore.flushAll();
      emit(AuthStatus.unauthenticated);
    } else {
      emit(AuthStatus.locked);
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
}

final globalAuth = AuthCubit();
