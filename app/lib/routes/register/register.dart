import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/core/widgets/logo.dart';
import 'package:mayflypass/forms/confirm_master_password.dart';
import 'package:mayflypass/forms/email.dart';
import 'package:mayflypass/forms/master_password.dart';
import 'package:mayflypass/router.dart';
import 'package:mayflypass/routes/register/form_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TapGestureRecognizer _signInTap;

  @override
  void initState() {
    super.initState();
    _signInTap = TapGestureRecognizer()..onTap = () => context.go('/login');
  }

  @override
  void dispose() {
    _signInTap.dispose();
    super.dispose();
  }

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
            body: MainCenterScrollable(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacer(),
                  Center(child: Logo()),
                  SizedBox(height: 22),
                  Center(
                    child: Text(
                      'Create account',
                      style: AppTheme.mainTitleStyle,
                    ),
                  ),
                  Spacer8,
                  Center(
                    child: Text(
                      'Your codes stay encrypted on this device.\nOne account to sync and restore.',
                      style: AppTheme.helperStyle,
                      textAlign: .center,
                    ),
                  ),
                  SizedBox(height: 44),
                  // email
                  MTextFormField(
                    labelText: l10n.email,
                    onChanged: cubit.emailChanged,
                    errorText: EmailValueError.toHuman(context, [
                      state.email.displayError,
                      state.apiEmailError,
                    ]),
                  ),
                  SpacerFormField,
                  // password
                  PasswordField(
                    labelText: l10n.masterPassword,
                    errorText: MasterPasswordValueError.toHuman(context, [
                      state.masterPassword.displayError,
                    ]),
                    onChanged: cubit.masterPasswordChanged,
                  ),
                  SpacerFormField,
                  // confirm password
                  PasswordField(
                    labelText: l10n.confirmMasterPassword,
                    errorText: ConfirmMasterPasswordValueError.toHuman(
                      context,
                      [state.confirmMasterPassword.displayError],
                    ),
                    onChanged: cubit.confirmMasterPasswordChanged,
                  ),
                  SpacerSection,
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
                  SpacerSection,
                  Spacer(),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: AppTheme.helperStyle,
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: AppTheme.helperStyleLink,
                            recognizer: _signInTap,
                          ),
                        ],
                      ),
                    ),
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
