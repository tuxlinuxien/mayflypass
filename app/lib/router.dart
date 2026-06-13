import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:mayflypass/auth/auth_cubit.dart';
import 'package:mayflypass/routes/home.dart';
import 'package:mayflypass/routes/login.dart';
import 'package:mayflypass/routes/splash.dart';

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final loc = state.matchedLocation;
      switch (authCubit.state) {
        case AuthStatus.loading:
          return loc == '/splash' ? null : '/splash';
        case AuthStatus.unauthenticated:
          return loc == '/login' ? null : '/login';
        case AuthStatus.authenticated:
          return loc == '/home' ? null : '/home';
      }
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (ctx, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (ctx, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (ctx, state) => const HomePage(),
      ),
    ],
  );
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
