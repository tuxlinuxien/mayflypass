import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/forms/master_password.dart';
import 'cubit.dart';

class UnlockPage extends StatelessWidget {
  const UnlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormCubit>(
      create: (context) => FormCubit(),
      child: BlocConsumer<FormCubit, UnlockFormState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          switch (state.status) {
            case FormStatus.success:
              globalAuth.unlock(); // send the user to the homepage.
            case FormStatus.failure:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.invalidMasterPassword),
                  backgroundColor: Colors.red,
                ),
              );
            default:
          }
        },
        builder: (context, state) {
          final cubit = context.read<FormCubit>();
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PasswordField(
                    labelText: l10n.masterPassword,
                    errorText: MasterPasswordValueError.toHuman(
                      context,
                      state.masterPassword.displayError,
                    ),
                    onChanged: cubit.masterPasswordChanged,
                  ),
                  Spacer16,
                  FilledButton(
                    onPressed: state.status == FormStatus.submitting
                        ? null
                        : cubit.unlock,
                    child: state.status == FormStatus.submitting
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(),
                          )
                        : Text(l10n.unlock),
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
