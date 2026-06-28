import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mayflypass/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _router = createRouter(gloablAuth);

  @override
  void initState() {
    super.initState();
    gloablAuth.checkAuth();
  }

  @override
  void dispose() {
    gloablAuth.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: gloablAuth,
      child: MaterialApp.router(
        title: 'Mayfly Pass',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        routerConfig: _router,
      ),
    );
  }
}
