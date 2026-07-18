import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/core/widgets/logo.dart';
import 'package:mayflypass/forms/username.dart';
import 'package:mayflypass/forms/master_password.dart';
import 'package:mayflypass/helpers/toasts.dart';

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
              showSuccess(context, l10n.loggedIn(state.username.value));
            case FormStatus.failure:
              if (state.apiError == null) return;
              showFailure(context, l10n.thereWasProblem);
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
                return MainCenterScrollable(
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
                        labelText: l10n.username,
                        onChanged: cubit.usernameChanged,
                        errorText: UsernameValueError.toHuman(context, [
                          state.username.displayError,
                          state.usernameError,
                        ]),
                      ),
                      SpacerFormField,
                      PasswordField(
                        labelText: l10n.masterPassword,
                        errorText: MasterPasswordValueError.toHuman(context, [
                          state.masterPassword.displayError,
                        ]),
                        onChanged: cubit.masterPasswordChanged,
                      ),
                      SpacerSection,
                      FilledButton(
                        onPressed: state.status == FormStatus.submitting
                            ? null
                            : cubit.submit,
                        child: Text('Sign in'),
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
