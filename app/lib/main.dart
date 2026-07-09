import 'package:drift/native.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (DEV_MODE) {
    setGlobalTestKek();
    initStore(MemoryStore());
    initDB(NativeDatabase.memory(logStatements: true));
    initDBTestFixtures(getGlobalKek()!);
    await globalStore.setEmail('yoann@mail.com');
    globalAuth.unlock();
  } else {
    initStore(FSStore());
    initDB();
  }

  logger.i('[API_URL] $API_URL');
  initRouter(globalAuth);
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
      child: MaterialApp.router(
        title: 'Mayfly Pass',
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        theme: generateThemeData(),
        darkTheme: generateThemeData(),
        themeMode: .dark,
        routerConfig: router,
      ),
    );
  }
}

ThemeData generateThemeData() {
  return ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromARGB(0xff, 0x6D, 0x28, 0xD9),
      brightness: Brightness.dark,
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
          ),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
          ),
        ),
      ),
    ),
  );
}
