import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus { loading, unauthenticated, unlocked, locked }

class AuthCubit extends Cubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.loading);

  Future<void> checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(AuthStatus.unauthenticated);
  }

  void unlocked() => emit(AuthStatus.unlocked);
  void locked() => emit(AuthStatus.locked);
  void logout() => emit(AuthStatus.unauthenticated);
}

final gloablAuth = AuthCubit();
