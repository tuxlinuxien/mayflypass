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
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Card(child: AccountItem(email: state.email ?? '')),
                  Spacer16,
                  Card(
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        BiometricUnlockItem(
                          value: state.biometricUnlock ?? false,
                          onChnaged: cubit.updateBiometricUnlock,
                        ),
                        LockoutAfterItem(
                          value: state.lockoutAfter ?? Duration(seconds: 30),
                          onChanged: cubit.updateLockoutAfter,
                        ),
                      ],
                    ),
                  ),
                  Spacer16,
                  Divider(),
                  Spacer16,
                  FilledButton(
                    onPressed: () => globalAuth.logout(),
                    child: Text(l10i.logout),
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
