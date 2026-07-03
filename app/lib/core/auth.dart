import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayflypass/core/core.dart';

enum AuthStatus { loading, unauthenticated, unlocked, locked }

class AuthCubit extends Cubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.loading);

  Future<void> checkAuth() async {
    final email = await StorageGetAccount();
    if (email == null) {
      emit(AuthStatus.unauthenticated);
    } else {
      emit(AuthStatus.unlocked);
    }
  }

  void unlocked() => emit(AuthStatus.unlocked);
  void locked() => emit(AuthStatus.locked);
  void logout() => emit(AuthStatus.unauthenticated);
}

final globalAuth = AuthCubit();
