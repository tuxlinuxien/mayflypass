import 'dart:io';

import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/helpers/sync.dart';

part 'cubit.freezed.dart';

enum SettingsStatus { loading, ready, sync }

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(SettingsStatus.loading) SettingsStatus status,
    @Default(null) String? email,
    @Default(null) DateTime? lastSync,
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
        lastSync: await globalStore.getLastSync(),
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

  Future<void> sync() async {
    emit(state.copyWith(status: .sync));

    try {
      await syncLocalAndRemote();
      emit(state.copyWith(lastSync: await globalStore.getLastSync()));
    } catch (e) {
      logger.e(e);
    } finally {
      emit(state.copyWith(status: .ready));
    }
  }
}
