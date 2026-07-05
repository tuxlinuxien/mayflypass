import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/forms/confirm_master_password.dart';
import 'package:mayflypass/forms/email.dart';
import 'package:mayflypass/forms/master_password.dart';
import 'package:mayflypass/router.dart';
import 'package:mayflypass/routes/register/form_cubit.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterFormCubit>(
      create: (context) => RegisterFormCubit(),
      child: BlocConsumer<RegisterFormCubit, RegisterFormState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          switch (state.status) {
            case FormStatus.success:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.accountCreatedSuccessfully),
                  backgroundColor: Colors.green,
                ),
              );
              router.go('/login');
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
          final cubit = context.read<RegisterFormCubit>();
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // email
                  TextField(
                    autofocus: true,
                    onChanged: cubit.emailChanged,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      errorText: EmailValueError.toHuman(
                        context,
                        state.email.displayError,
                        state.apiEmailError,
                      ),
                    ),
                  ),
                  Spacer16,
                  // password
                  PasswordField(
                    labelText: l10n.masterPassword,
                    errorText: MasterPasswordValueError.toHuman(
                      context,
                      state.masterPassword.displayError,
                    ),
                    onChanged: cubit.masterPasswordChanged,
                  ),
                  Spacer16,
                  // confirm password
                  PasswordField(
                    labelText: l10n.confirmMasterPassword,
                    errorText: ConfirmMasterPasswordValueError.toHuman(
                      context,
                      state.confirmMasterPassword.displayError,
                    ),
                    onChanged: cubit.confirmMasterPasswordChanged,
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
                        : Text(l10n.register),
                  ),
                  Spacer32,
                  const Or(),
                  Spacer32,
                  OutlinedButton(
                    onPressed: () => context.go('/login'),
                    child: Text(l10n.loginToAccount),
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
