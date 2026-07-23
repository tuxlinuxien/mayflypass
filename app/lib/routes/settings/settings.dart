import 'package:intl/intl.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/router.dart';
import 'package:mayflypass/routes/settings/cubit.dart';
import 'package:mayflypass/routes/settings/widgets/backup_secrets.dart';
import 'package:mayflypass/routes/settings/widgets/import_secrets.dart';
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
            appBar: AppBar(title: Text(l10i.settings)),
            body: SingleChildScrollView(
              child: MainContainer(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Text(l10i.accountSection, style: AppTheme.helperStyle),
                    Spacer8,
                    Surface(
                      child: Column(
                        children: [
                          IconRow(
                            icon: Icons.account_circle,
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(l10i.username),
                                Text(
                                  state.username ?? '',
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
                                      Text(l10i.lastSynchronization),
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
                                IconButton.filled(
                                  onPressed: state.status == .sync
                                      ? null
                                      : cubit.sync,
                                  icon: state.status == .sync
                                      ? SizedBox.square(
                                          dimension: 24,
                                          child: CircularProgressIndicator(),
                                        )
                                      : Icon(Icons.sync),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1),
                          IconRow(
                            icon: Icons.lock_reset,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text(l10i.changePassword),
                                      Text(
                                        l10i.changePasswordDescription,
                                        style: AppTheme.helperStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton.filled(
                                  onPressed: () {
                                    router.push('/change-password');
                                  },
                                  icon: Icon(Icons.arrow_forward),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SpacerSection,
                    Text(l10i.securitySection, style: AppTheme.helperStyle),
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
                                      Text(l10i.biometricUnlock),
                                      Text(
                                        l10i.biometricUnlockDescription,
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
                                      : (_) => cubit.updateBiometricUnlock(
                                          l10i.biometricUnlockReason,
                                        ),
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
                                      Text(l10i.autoLock),
                                      Text(
                                        l10i.autoLockDescription,
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
                    Text(l10i.backupImportSection, style: AppTheme.helperStyle),
                    SizedBox(height: 9),
                    Surface(
                      child: Column(
                        children: [
                          IconRow(
                            icon: Icons.cloud_download,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text(l10i.backup),
                                      Text(
                                        l10i.backupDescription,
                                        style: AppTheme.helperStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                BackupSecrets(),
                              ],
                            ),
                          ),
                          Divider(height: 1),
                          IconRow(
                            icon: Icons.cloud_upload,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text(l10i.import),
                                      Text(
                                        l10i.importDescription,
                                        style: AppTheme.helperStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                ImportSecrets(),
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
                        l10i.logout,
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
