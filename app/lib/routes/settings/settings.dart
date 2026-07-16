import 'package:intl/intl.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/routes/settings/cubit.dart';
import 'package:mayflypass/routes/settings/widgets/lockout_dropdown.dart';

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
                    Spacer8,
                    Surface(
                      child: Column(
                        children: [
                          IconRow(
                            icon: Icons.account_circle,
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text('E-mail'),
                                Text(
                                  state.email ?? '',
                                  style: AppTheme.helperStyle,
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1),
                          IconRow(
                            icon: Icons.cloud_sync_outlined,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text('Last synchronization'),
                                      Text(
                                        state.lastSync == null
                                            ? '--'
                                            : DateFormat(
                                                'yyyy-MM-dd HH:mm',
                                              ).format(state.lastSync!),
                                        style: AppTheme.helperStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 44,
                                  width: 44,
                                  child: state.status == .sync
                                      ? CircularProgressIndicator()
                                      : IconButton.filled(
                                          onPressed: cubit.sync,
                                          icon: Icon(Icons.sync),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SpacerSection,
                    Text('Security', style: AppTheme.helperStyle),
                    Spacer8,
                    Surface(
                      child: Column(
                        children: [
                          IconRow(
                            icon: Icons.fingerprint,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text('Biometric unlock'),
                                      Text(
                                        'Use your fingerprint to unlock the application',
                                        style: AppTheme.helperStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: state.biometricUnlock ?? false,
                                  onChanged:
                                      ((state.biometricUnlockAvailable ??
                                              false) ==
                                          false)
                                      ? null
                                      : (_) => cubit.updateBiometricUnlock(),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1),
                          IconRow(
                            icon: Icons.lock,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text('Auto-lock'),
                                      Text(
                                        'Automatically lock after',
                                        style: AppTheme.helperStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                LockoutAfterDropdown(
                                  value:
                                      state.lockoutAfter ??
                                      LOCK_AFTER_CHOICES[0],
                                  onChanged: cubit.updateLockoutAfter,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SpacerSection,
                    Text('Backup / Import', style: AppTheme.helperStyle),
                    SizedBox(height: 9),
                    Surface(
                      child: Column(
                        children: [
                          IconRow(
                            icon: Icons.cloud_download,
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text('Backup'),
                                Text(
                                  'Download your secrets onto your device',
                                  style: AppTheme.helperStyle,
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1),
                          IconRow(
                            icon: Icons.cloud_upload,
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text('Import'),
                                Text(
                                  'Import secrets into you account',
                                  style: AppTheme.helperStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SpacerSection,
                    Divider(height: 1),
                    SpacerSection,
                    OutlinedButton.icon(
                      style: ButtonStyle(
                        iconColor: WidgetStatePropertyAll(AppTheme.DangerColor),
                        side: WidgetStatePropertyAll(
                          BorderSide(color: AppTheme.DangerColor),
                        ),
                      ),
                      onPressed: globalAuth.logout,
                      label: Text(
                        'Logout',
                        style: TextStyle(color: AppTheme.DangerColor),
                      ),
                      icon: Icon(Icons.logout),
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

class IconRow extends StatelessWidget {
  final IconData icon;
  final Widget child;
  const IconRow({super.key, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: .start,
        spacing: 16,
        children: [
          _icon(),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _icon() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 44,
        minWidth: 44,
        maxHeight: 44,
        minHeight: 44,
      ),
      decoration: BoxDecoration(
        color: Color(0x248b5cf6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: AppTheme.BrightColor),
        ),
      ),
    );
  }
}
