import 'package:go_router/go_router.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/forms/email.dart';
import 'package:mayflypass/forms/master_password.dart';

import 'form_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginFormCubit>(
      create: (context) => LoginFormCubit(),
      child: BlocConsumer<LoginFormCubit, LoginFormState>(
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
              globalAuth.unlock(); // send the user to the homepage.
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
                  MTextFormField(
                    labelText: l10n.email,
                    onChanged: cubit.emailChanged,
                    errorText: EmailValueError.toHuman(context, [
                      state.email.displayError,
                      state.emailError,
                    ]),
                  ),
                  Spacer16,
                  PasswordField(
                    labelText: l10n.masterPassword,
                    errorText: MasterPasswordValueError.toHuman(context, [
                      state.masterPassword.displayError,
                    ]),
                    onChanged: cubit.masterPasswordChanged,
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
                  OutlinedButton(
                    onPressed: () => context.go('/register'),
                    child: Text(l10n.registerNewAccount),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
