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
        biometricUnlock: await globalStore.hasKek(),
        biometricUnlockAvailable: (Platform.isAndroid || Platform.isIOS),
        status: SettingsStatus.ready,
      ),
    );
  }

  Future<void> updateBiometricUnlock(bool value) async {
    emit(state.copyWith(status: .loading));
    final kek = getGlobalKek();
    if (kek == null) {
      emit(state.copyWith(status: .ready, biometricUnlock: false));
      return;
    }
    var hasKek = await globalStore.hasKek();
    if (hasKek) {
      await globalStore.deleteKek();
    } else {
      await globalStore.setKek(kek);
    }

    hasKek = await globalStore.hasKek();
    emit(state.copyWith(status: .ready, biometricUnlock: hasKek));
  }

  Future<void> updateLockoutAfter(Duration value) async {
    emit(state.copyWith(status: .loading));
    await globalStore.setSettingsLockAfterDuration(value);
    emit(state.copyWith(status: .ready, lockoutAfter: value));
  }
}
