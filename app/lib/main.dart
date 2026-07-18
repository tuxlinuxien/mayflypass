import 'package:drift/native.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize all routes
  initRouter();
  if (DEV_MODE) {
    setGlobalTestKek();
    initStore(MemoryStore());
    initDB(NativeDatabase.memory(logStatements: true));
    initDBTestFixtures(getGlobalKek()!);
    await globalStore.setEmail('yoann@mail.com');
    globalAuth.unlocked();
    router.go('/home');
  } else {
    initStore(FSStore());
    initDB();
  }
  logger.i('[API_URL] $API_URL');
  await BrandIcons.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (!DEV_MODE) {
      globalAuth.checkAuth();
    }
  }

  @override
  void dispose() {
    globalAuth.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: globalAuth,
      child: BlocListener<AuthCubit, AuthStatus>(
        listener: (context, state) {
          switch (state) {
            case .loading:
              router.go('/splash');
            case .locked:
              router.go('/unlock');
            case .unlocked:
              router.go('/home');
            case .unauthenticated:
              router.go('/login');
          }
        },
        child: MaterialApp.router(
          title: 'Mayfly Pass',
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en')],
          theme: AppTheme.dark,
          darkTheme: AppTheme.dark,
          themeMode: .dark,
          routerConfig: router,
        ),
      ),
    );
  }
}
