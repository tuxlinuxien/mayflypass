import 'package:go_router/go_router.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayflypass/routes/login/form_values.dart';

import 'form_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginFormCubit(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => __LoginViewState();
}

class __LoginViewState extends State<_LoginView> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginFormCubit, LoginFormState>(
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        switch (state.status) {
          case FormStatus.success:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.loggedIn(state.email.value)),
                backgroundColor: Colors.green,
              ),
            );
            gloablAuth.unlocked(); // send the user to the homepage.
          case FormStatus.failure:
            if (state.apiError == null) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.thereWasProblem),
                backgroundColor: Colors.red,
              ),
            );
          default:
          // do nothing
        }
      },
      builder: (context, state) {
        final cubit = context.read<LoginFormCubit>();
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  autofocus: true,
                  onChanged: cubit.emailChanged,
                  decoration: InputDecoration(
                    label: Text(l10n.email),
                    prefixIcon: const Icon(Icons.mail),
                    errorText: _emailError(
                      context,
                      state.email.displayError,
                      state.emailError,
                    ),
                  ),
                ),
                Spacer16,
                TextField(
                  obscureText: _obscurePassword,
                  onChanged: cubit.masterPasswordChanged,
                  decoration: InputDecoration(
                    label: Text(l10n.masterPassword),
                    prefixIcon: const Icon(Icons.lock),
                    errorText: _passwordError(
                      context,
                      state.masterPassword.displayError,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                Spacer16,
                FilledButton(
                  onPressed: state.status == FormStatus.submitting
                      ? null
                      : cubit.submit,
                  child: state.status == FormStatus.submitting
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(),
                        )
                      : Text(l10n.login),
                ),
                Spacer32,
                const Or(),
                Spacer32,
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: Text(l10n.registerNewAccount),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String? _emailError(
  BuildContext context,
  EmailError? formError,
  EmailError? apiError,
) {
  final error = formError ?? apiError;
  if (error == null) return null;
  final l10n = AppLocalizations.of(context)!;
  return switch (error) {
    EmailRequiredError() => l10n.fieldRequired,
    EmailInvalidError() => l10n.emailInvalid,
    EmailInvalidCredentialsError() => l10n.invalidCrentials,
  };
}

String? _passwordError(BuildContext context, MasterPasswordError? error) {
  if (error == null) return null;
  final l10n = AppLocalizations.of(context)!;
  return switch (error) {
    MasterPasswordRequiredError() => l10n.fieldRequired,
  };
}
