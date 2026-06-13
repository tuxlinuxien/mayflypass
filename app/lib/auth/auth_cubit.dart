import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus { loading, unauthenticated, authenticated }

class AuthCubit extends Cubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.loading);

  Future<void> checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(AuthStatus.unauthenticated);
  }

  void login() => emit(AuthStatus.authenticated);
  void logout() => emit(AuthStatus.unauthenticated);
}
