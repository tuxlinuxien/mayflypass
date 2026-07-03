import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayflypass/core/core.dart';

enum AuthStatus { loading, unauthenticated, unlocked, locked }

class AuthCubit extends Cubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.loading);

  Future<void> checkAuth() async {
    final email = await storage.getEmail();
    final unlockKeyBytes = await storage.getUnlockKey();
    if (email == null || unlockKeyBytes == null) {
      emit(AuthStatus.unauthenticated);
    } else {
      emit(AuthStatus.locked);
    }
  }

  void unlock() => emit(AuthStatus.unlocked);
  void lock() => emit(AuthStatus.locked);
  void logout() => emit(AuthStatus.unauthenticated);
}

final globalAuth = AuthCubit();
