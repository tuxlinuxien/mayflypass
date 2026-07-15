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
            appBar: AppBar(title: Text('Settings')),
            body: SingleChildScrollView(
              child: MainContainer(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Text('Account', style: AppTheme.helperStyle),
                    SizedBox(height: 9),
                    Surface(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Column(
                          children: [
                            Text('account'),
                            Spacer8,
                            Divider(
                              height: 1,
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                            Spacer8,
                            Text('account'),
                          ],
                        ),
                      ),
                    ),
                    SpacerSection,
                    Text('Security', style: AppTheme.helperStyle),
                    SizedBox(height: 9),
                    Surface(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('toto'),
                      ),
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
