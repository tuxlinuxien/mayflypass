import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const testing = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (testing) {
    initStore(MemoryStore());
    setGlobalTestKek();
    await globalStore.setEmail('yoann@mail.com');
    globalAuth.unlock();
  } else {
    initStore(FSStore());
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
    if (testing == false) {
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
        theme: ThemeData.dark(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: .dark,
        routerConfig: router,
      ),
    );
  }
}
