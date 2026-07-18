import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/database/helpers.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/helpers/sync.dart';
import 'package:mayflypass/secure/encryption.dart';

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
    var biometricUnlockAvailable = false;
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        final LocalAuthentication auth = LocalAuthentication();
        biometricUnlockAvailable = await auth.isDeviceSupported();
      } catch (e) {
        logger.e(e);
        biometricUnlockAvailable = false;
      }
    }

    emit(
      state.copyWith(
        email: await globalStore.getEmail(),
        lockoutAfter: await globalStore.getSettingsLockAfterDuration(),
        biometricUnlock: await globalStore.hasKek(),
        biometricUnlockAvailable: biometricUnlockAvailable,
        lastSync: await globalStore.getLastSync(),
        status: SettingsStatus.ready,
      ),
    );
  }

  Future<void> updateBiometricUnlock() async {
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
      try {
        final LocalAuthentication auth = LocalAuthentication();
        final isAuthenticated = await auth.authenticate(
          localizedReason: 'Unlock',
        );
        if (isAuthenticated) {
          await globalStore.setKek(kek);
        }
      } catch (e) {
        logger.e(e);
      }
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

  Future<bool> exportSecrets() async {
    try {
      final name =
          'mayflypass_export_${DateTime.now().millisecondsSinceEpoch}.json';
      final kek = getGlobalKek()!;
      final items = await globalDB.selectLocalStorage(withDeleted: false);
      final output = <String, Map<String, dynamic>>{};
      for (final item in items) {
        try {
          output[item.id] = (await decryptDataBox(
            kek,
            item.encryptedDek,
            item.encryptedPayload,
          )).writeToJsonMap();
        } catch (e) {
          logger.e(e);
        }
      }
      final content = jsonEncode(output);
      return await FilePicker.saveFile(
            fileName: name,
            type: FileType.any,
            bytes: Utf8Encoder().convert(content),
          ) !=
          null;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<int?> importSecrets() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: .custom,
        allowMultiple: false,
        allowedExtensions: ['json'],
        withData: true,
      );
      if (result == null) {
        return null;
      }
      final dynResult = jsonDecode(
        Utf8Decoder().convert(result.files[0].bytes!.toList()),
      );
      final mapResult = dynResult as Map<String, dynamic>;
      var totalImported = 0;
      final kek = getGlobalKek()!;
      for (final k in mapResult.keys) {
        try {
          final dbox = DataBox.create()..mergeFromJsonMap(mapResult[k]);
          final (encryptedDek, encryptedPayload) = await encryptDataBox(
            kek,
            dbox,
          );
          await globalDB.upsertLocalStorage(
            LocalStorageData(
              id: k,
              updatedAtMs: generateVersion(),
              deleted: false,
              encryptedDek: encryptedDek,
              encryptedPayload: encryptedPayload,
            ),
          );
          totalImported++;
        } catch (e) {
          logger.e(e);
        }
      }
      await syncLocalAndRemote();
      return totalImported;
    } catch (e) {
      logger.e(e);
    }
    return null;
  }
}
