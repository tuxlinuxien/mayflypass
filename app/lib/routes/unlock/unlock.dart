import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/core/widgets/logo.dart';
import 'package:mayflypass/forms/master_password.dart';
import 'cubit.dart';

class UnlockPage extends StatefulWidget {
  const UnlockPage({super.key});

  @override
  State<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends State<UnlockPage> {
  late final TapGestureRecognizer _signOutTap;

  @override
  void initState() {
    super.initState();
    _signOutTap = TapGestureRecognizer()..onTap = () => context.go('/login');
  }

  @override
  void dispose() {
    _signOutTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormCubit>(
      create: (context) => FormCubit()..load(),
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
            body: MainCenterScrollable(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacer(),
                  Center(child: Logo()),
                  SizedBox(height: 22),
                  Center(
                    child: Text('Locked vault', style: AppTheme.mainTitleStyle),
                  ),
                  Spacer8,
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(Icons.account_circle),
                      SizedBox(width: 10),
                      Text(
                        state.email,
                        style: AppTheme.helperStyle,
                        textAlign: .center,
                      ),
                    ],
                  ),
                  SizedBox(height: 44),
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
                        : cubit.unlock,
                    child: state.status == FormStatus.submitting
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(),
                          )
                        : Text(l10n.unlock),
                  ),
                  SpacerFormField,
                  OutlinedButton(
                    onPressed: state.status == FormStatus.submitting
                        ? null
                        : cubit.unlock,
                    child: Row(
                      crossAxisAlignment: .center,
                      mainAxisAlignment: .center,
                      children: [
                        Icon(
                          Icons.fingerprint,
                          color: AppTheme.BrightColor,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text('Unlock with fingerprint'),
                      ],
                    ),
                  ),
                  SpacerSection,
                  Spacer(),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Not you? ',
                        style: AppTheme.helperStyle,
                        children: [
                          TextSpan(
                            text: 'Sign out',
                            style: AppTheme.helperStyleLink,
                            recognizer: _signOutTap,
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
