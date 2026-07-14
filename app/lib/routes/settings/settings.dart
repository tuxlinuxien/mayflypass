import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/routes/settings/cubit.dart';
import 'package:mayflypass/routes/settings/widgets/account.dart';
import 'package:mayflypass/routes/settings/widgets/biometric_unlock.dart';
import 'package:mayflypass/routes/settings/widgets/lockout_after.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit()..load(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final l10i = AppLocalizations.of(context)!;
          final cubit = context.read<SettingsCubit>();
          return Scaffold(
            appBar: AppBar(title: Text(l10i.settings)),
            body: SingleChildScrollView(
              child: MainContainer(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Text(
                      'Account',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Spacer8,
                    AccountBlock(email: state.email ?? ''),
                    SpacerFormField,
                    Text(
                      'Security',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Spacer8,
                    SecurityBlock(
                      biometricUnlockValue: state.biometricUnlock ?? false,
                      onBiometricUnlockChanged: cubit.updateBiometricUnlock,
                      lockoutAfterValue:
                          state.lockoutAfter ?? Duration(seconds: 30),
                      onLockoutAfterValueChanges: cubit.updateLockoutAfter,
                    ),
                    SpacerFormField,
                    Divider(),
                    SpacerFormField,
                    FilledButton(
                      onPressed: () => globalAuth.logout(),
                      child: Text(l10i.logout),
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

class AccountBlock extends StatelessWidget {
  final String email;
  const AccountBlock({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Padding(
        padding: EdgeInsetsGeometry.all(DEFAULT_SPACING),
        child: AccountItem(email: email),
      ),
    );
  }
}

class SecurityBlock extends StatelessWidget {
  final bool biometricUnlockValue;
  final Function(bool) onBiometricUnlockChanged;
  final Duration lockoutAfterValue;
  final Function(Duration) onLockoutAfterValueChanges;

  const SecurityBlock({
    super.key,
    required this.biometricUnlockValue,
    required this.onBiometricUnlockChanged,
    required this.lockoutAfterValue,
    required this.onLockoutAfterValueChanges,
  });

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Padding(
        padding: EdgeInsetsGeometry.all(DEFAULT_SPACING),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            BiometricUnlockItem(
              value: biometricUnlockValue,
              onChnaged: onBiometricUnlockChanged,
            ),
            SpacerFormField,
            LockoutAfterItem(
              value: lockoutAfterValue,
              onChanged: onLockoutAfterValueChanges,
            ),
          ],
        ),
      ),
    );
  }
}
