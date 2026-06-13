import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayflypass/auth/auth_cubit.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/router.dart';

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
  final _authCubit = AuthCubit();
  late final _router = createRouter(_authCubit);

  @override
  void initState() {
    super.initState();
    _authCubit.checkAuth();
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authCubit,
      child: MaterialApp.router(
        title: 'Mayfly Pass',
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        routerConfig: _router,
      ),
    );
  }
}
