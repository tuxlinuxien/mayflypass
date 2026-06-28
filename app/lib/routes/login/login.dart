import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'email',
                border: const OutlineInputBorder(),
                suffixIcon: Icon(Icons.mail),
              ),
            ),
            Spacer16,
            TextField(
              controller: _passwordController,
              obscureText: _obscure,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Master password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            Spacer16,
            FilledButton(onPressed: () {}, child: const Text('Unlock')),
          ],
        ),
      ),
    );
  }
}
