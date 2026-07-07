import 'dart:io';

import 'package:mayflypass/core/core.dart';

part 'cubit.freezed.dart';

enum SettingsStatus { loading, ready }

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(SettingsStatus.loading) SettingsStatus status,
    @Default(null) String? email,
    @Default(null) Duration? lockoutAfter,
    @Default(null) bool? biometricUnlock,
    @Default(null) bool? biometricUnlockAvailable,
  }) = _SettingsState;
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  Future<void> load() async {
    emit(
      state.copyWith(
        email: await globalStore.getEmail(),
        lockoutAfter: await globalStore.getSettingsLockAfterDuration(),
        biometricUnlock: await globalStore.getSettingsBiometricEnabled(),
        biometricUnlockAvailable: (Platform.isAndroid || Platform.isIOS),
        status: SettingsStatus.ready,
      ),
    );
  }

  Future<void> updateBiometricUnlock(bool value) async {
    emit(state.copyWith(status: .loading));
    await globalStore.setSettingsBiometricEnabled(value);
    emit(state.copyWith(status: .ready, biometricUnlock: value));
  }

  Future<void> updateLockoutAfter(Duration value) async {
    emit(state.copyWith(status: .loading));
    await globalStore.setSettingsLockAfterDuration(value);
    emit(state.copyWith(status: .ready, lockoutAfter: value));
  }
}
