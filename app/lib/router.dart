import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/routes/change_password/change_password.dart';
import 'package:mayflypass/routes/home/home.dart';
import 'package:mayflypass/routes/login/login.dart';
import 'package:mayflypass/routes/register/register.dart';
import 'package:mayflypass/routes/totp/totp_scanner.dart';
import 'package:mayflypass/routes/settings/settings.dart';
import 'package:mayflypass/routes/splash.dart';
import 'package:mayflypass/routes/totp/totp_manual.dart';
import 'package:mayflypass/routes/unlock/unlock.dart';

late final GoRouter router;

class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    globalAuth.refreshLockAfter();
    super.didPush(route, previousRoute);
  }

  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    globalAuth.refreshLockAfter();
    super.didChangeTop(topRoute, previousTopRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    globalAuth.refreshLockAfter();
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    globalAuth.refreshLockAfter();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    globalAuth.refreshLockAfter();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    globalAuth.refreshLockAfter();
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    globalAuth.refreshLockAfter();
    super.didStopUserGesture();
  }
}

void initRouter() {
  router = GoRouter(
    initialLocation: '/splash',
    observers: [RouterObserver()],
    routes: [
      GoRoute(path: '/splash', builder: (ctx, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (ctx, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (ctx, state) => const RegisterPage()),
      GoRoute(path: '/unlock', builder: (ctx, state) => const UnlockPage()),
      GoRoute(path: '/home', builder: (ctx, state) => const HomePage()),
      GoRoute(path: '/settings', builder: (ctx, state) => const SettingsPage()),
      GoRoute(
        path: '/totp',
        builder: (ctx, state) {
          if (Platform.isAndroid || Platform.isIOS) {
            return const TotpScannerPage();
          }
          return const TotpManualPage(id: null);
        },
      ),
      GoRoute(
        path: '/totp/:id',
        builder: (ctx, state) {
          return TotpManualPage(id: state.pathParameters['id']);
        },
      ),
      GoRoute(
        path: '/totp-scanner',
        builder: (ctx, state) => const TotpScannerPage(),
      ),
      GoRoute(
        path: '/totp-manual',
        builder: (ctx, state) => const TotpManualPage(id: null),
      ),
      GoRoute(
        path: '/change-password',
        builder: (ctx, state) => const ChangePasswordPage(),
      ),
    ],
  );
}
