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
  // initialize brand icons asset
  await BrandIcons.init();

  if (DEV_MODE) {
    setGlobalTestKek();
    initStore(MemoryStore());
    initDB(NativeDatabase.memory(logStatements: true));
    initDBTestFixtures(getGlobalKek()!);
    await globalStore.setUsername('username1');
    globalAuth.unlocked();
    router.go('/home');
  } else {
    initStore(FSStore());
    initDB();
  }

  final lang = await globalStore.getLang();
  runApp(MyApp(lang: lang));
}

class MyApp extends StatefulWidget {
  final String lang;

  const MyApp({super.key, required this.lang});

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
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale.fromSubtags(languageCode: widget.lang),
          theme: AppTheme.dark,
          darkTheme: AppTheme.dark,
          themeMode: .dark,
          routerConfig: router,
        ),
      ),
    );
  }
}
