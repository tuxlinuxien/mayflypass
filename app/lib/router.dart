import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/routes/home.dart';
import 'package:mayflypass/routes/login/login.dart';
import 'package:mayflypass/routes/register/register.dart';
import 'package:mayflypass/routes/settings/settings.dart';
import 'package:mayflypass/routes/splash.dart';
import 'package:mayflypass/routes/totp/totp.dart';
import 'package:mayflypass/routes/unlock/unlock.dart';

late final GoRouter router;

void initRouter(AuthCubit authCubit) {
  router = createRouter(authCubit);
}

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
          return ['/login', '/register'].contains(loc) ? null : '/login';
        case AuthStatus.locked:
          return ['/unlock', '/login', '/register'].contains(loc)
              ? null
              : '/unlock';
        case AuthStatus.unlocked:
          return ['/home', '/settings', '/totp'].contains(loc) ? null : '/home';
      }
    },
    routes: [
      GoRoute(path: '/splash', builder: (ctx, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (ctx, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (ctx, state) => const RegisterPage()),
      GoRoute(path: '/unlock', builder: (ctx, state) => const UnlockPage()),
      GoRoute(path: '/home', builder: (ctx, state) => const HomePage()),
      GoRoute(path: '/settings', builder: (ctx, state) => const SettingsPage()),
      GoRoute(path: '/totp', builder: (ctx, state) => const TotpPage(id: null)),
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
