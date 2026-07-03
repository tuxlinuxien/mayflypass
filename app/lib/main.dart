import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final armor = await BiometricStorage().linuxCheckAppArmorError();
  final canAuth = await BiometricStorage().canAuthenticate();
  logger.w('armor $armor canAuth $canAuth');
  initSecureStorage(StorageTest());
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
    globalAuth.checkAuth();
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
        //theme: AppTheme.dark,
        // darkTheme: AppTheme.dark,
        routerConfig: router,
      ),
    );
  }
}
