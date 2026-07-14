import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/core/widgets/logo.dart';
import 'package:mayflypass/forms/email.dart';
import 'package:mayflypass/forms/master_password.dart';

import 'form_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TapGestureRecognizer _signUpTap;

  @override
  void initState() {
    super.initState();
    _signUpTap = TapGestureRecognizer()..onTap = () => context.go('/register');
  }

  @override
  void dispose() {
    _signUpTap.dispose();
    super.dispose();
  }

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
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: MainContainer(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Spacer(),
                            Center(child: Logo()),
                            SizedBox(height: 22),
                            Center(
                              child: Text(
                                'Welcome back',
                                style: AppTheme.mainTitleStyle,
                              ),
                            ),
                            Spacer8,
                            Center(
                              child: Text(
                                'Sign in to Mayfly Pass to sync your codes.',
                                style: AppTheme.helperStyle,
                              ),
                            ),
                            SizedBox(height: 44),
                            MTextFormField(
                              labelText: l10n.email,
                              onChanged: cubit.emailChanged,
                              errorText: EmailValueError.toHuman(context, [
                                state.email.displayError,
                                state.emailError,
                              ]),
                            ),
                            SpacerFormField,
                            PasswordField(
                              labelText: l10n.masterPassword,
                              errorText: MasterPasswordValueError.toHuman(
                                context,
                                [state.masterPassword.displayError],
                              ),
                              onChanged: cubit.masterPasswordChanged,
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
                                  : Text('Sign in'),
                            ),
                            SpacerSection,
                            Spacer(),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  text: 'New here? ',
                                  style: AppTheme.helperStyle,
                                  children: [
                                    TextSpan(
                                      text: 'Create an account',
                                      style: AppTheme.helperStyleLink,
                                      recognizer: _signUpTap,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
