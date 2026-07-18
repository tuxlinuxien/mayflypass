import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/forms/confirm_master_password.dart';
import 'package:mayflypass/forms/master_password.dart';
import 'package:mayflypass/helpers/toasts.dart';

import 'cubit.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChangePasswordCubit>(
      create: (context) => ChangePasswordCubit(),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          switch (state.status) {
            case ChangePasswordStatus.success:
              showSuccess(context, l10n.changePasswordSuccess);
              globalAuth.logout();
            case ChangePasswordStatus.failure:
              showFailure(context, l10n.thereWasProblem);
            default:
          }
        },
        builder: (context, state) {
          final cubit = context.read<ChangePasswordCubit>();
          return Scaffold(
            appBar: AppBar(title: Text('Change password')),
            body: SingleChildScrollView(
              child: MainContainer(
                child: Column(
                  children: [
                    PasswordField(
                      labelText: 'Old password',
                      onChanged: cubit.changeOldPassword,
                      errorText: MasterPasswordValueError.toHuman(context, [
                        state.oldPassword.displayError,
                        state.oldPasswordError,
                      ]),
                    ),
                    SpacerFormField,
                    PasswordField(
                      labelText: 'New password',
                      onChanged: cubit.changeNewPassword,
                      errorText: MasterPasswordValueError.toHuman(context, [
                        state.newPassword.displayError,
                        state.newPasswordError,
                      ]),
                    ),
                    SpacerFormField,
                    PasswordField(
                      labelText: 'Confirm new password',
                      onChanged: cubit.changeConfirmNewPassword,
                      errorText: ConfirmMasterPasswordValueError.toHuman(
                        context,
                        [state.confirmNewPassword.displayError],
                      ),
                    ),
                    SpacerSection,
                    FilledButton(
                      onPressed: state.status == .submitting
                          ? null
                          : cubit.submit,
                      child: Text('Submit'),
                    ),
                    SpacerSection,
                    Row(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppTheme.helperTextColor,
                        ),
                        Expanded(
                          child: Text(
                            'This action might take a while because secrets will be re-encrypted with new keys. '
                            'After completion you will have to login again across all your devices.',
                            style: AppTheme.helperStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
