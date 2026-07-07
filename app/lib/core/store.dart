import 'dart:io';

import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hex/hex.dart';
import 'package:mayflypass/core/logger.dart';
import 'package:mayflypass/secure/secure.dart';

abstract class Store {
  // api
  Future<String?> getApiRefreshToken();
  Future<void> setApiRefreshToken(String value);
  Future<void> deleteApiRefreshToken();

  // account
  Future<String?> getEmail();
  Future<void> setEmail(String value);
  Future<List<int>?> getUnlockKey();
  Future<void> setUnlockKey(List<int> value);

  // kek secure store
  Future<void> setKek(SecretKey value);
  Future<SecretKey?> getKek();

  // settings
  Future<bool> getSettingsBiometricEnabled();
  Future<void> setSettingsBiometricEnabled(bool value);
  Future<Duration> getSettingsLockAfterDuration();
  Future<void> setSettingsLockAfterDuration(Duration value);

  Future<void> flushAll();
}

class MemoryStore extends Store {
  final values = <String, dynamic>{};

  MemoryStore();

  @override
  Future<String?> getApiRefreshToken() async {
    logger.d('getApiRefreshToken');
    return values['refresh_token'] as String?;
  }

  @override
  Future<void> setApiRefreshToken(String value) async {
    logger.d('setApiRefreshToken');
    values['refresh_token'] = value;
  }

  @override
  Future<void> deleteApiRefreshToken() async {
    logger.d('deleteApiRefreshToken');
    values['refresh_token'] = null;
  }

  @override
  Future<String?> getEmail() async {
    logger.d('getEmail');
    return values['email'] as String?;
  }

  @override
  Future<void> setEmail(String value) async {
    logger.d('setEmail');
    values['email'] = value;
  }

  @override
  Future<List<int>?> getUnlockKey() async {
    logger.d('getUnlockKey');
    final value = values['unlock_key'] as String?;
    if (value == null) {
      return null;
    }
    return HEX.decode(value);
  }

  @override
  Future<void> setUnlockKey(List<int> value) async {
    logger.d('setUnlockKey');
    values['unlock_key'] = HEX.encode(value);
  }

  @override
  Future<void> setKek(SecretKey value) async {}

  @override
  Future<SecretKey?> getKek() async {
    return null;
  }

  @override
  Future<bool> getSettingsBiometricEnabled() async {
    final value = values['settings_biometric_enabled'] as bool?;
    return value ?? false;
  }

  @override
  Future<void> setSettingsBiometricEnabled(bool value) async {
    values['settings_biometric_enabled'] = value;
  }

  @override
  Future<Duration> getSettingsLockAfterDuration() async {
    final value = values['settings_lock_after_duration'] as int?;
    return Duration(seconds: value ?? 30);
  }

  @override
  Future<void> setSettingsLockAfterDuration(Duration value) async {
    values['settings_lock_after_duration'] = value.inSeconds;
  }

  @override
  Future<void> flushAll() async {}
}

class FSStore extends Store {
  FSStore();

  FlutterSecureStorage _getSafeStorage() {
    return FlutterSecureStorage(
      aOptions: AndroidOptions(storageNamespace: 'safe'),
      iOptions: IOSOptions(accountName: 'safe'),
    );
  }

  FlutterSecureStorage? _getCriticalStorage() {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return null;
    }
    return FlutterSecureStorage(
      aOptions: AndroidOptions.biometric(
        storageNamespace: 'critical',
        enforceBiometrics: true,
      ),
      iOptions: IOSOptions(accountName: 'critical', useSecureEnclave: true),
    );
  }

  @override
  Future<String?> getApiRefreshToken() async {
    logger.d('getApiRefreshToken');
    return await _getSafeStorage().read(key: 'api::refresh_token');
  }

  @override
  Future<void> setApiRefreshToken(String value) async {
    logger.d('setApiRefreshToken');
    await _getSafeStorage().write(key: 'api::refresh_token', value: value);
  }

  @override
  Future<void> deleteApiRefreshToken() async {
    logger.d('deleteApiRefreshToken');
    await _getSafeStorage().delete(key: 'api::refresh_token');
  }

  @override
  Future<String?> getEmail() async {
    logger.d('getEmail');
    return await _getSafeStorage().read(key: 'account::email');
  }

  @override
  Future<void> setEmail(String value) async {
    logger.d('setEmail');
    await _getSafeStorage().write(key: 'account::email', value: value);
  }

  @override
  Future<List<int>?> getUnlockKey() async {
    logger.d('getUnlockKey');
    final value = await _getSafeStorage().read(key: 'account::unlock_key');
    if (value == null) {
      return null;
    }
    return HEX.decode(value);
  }

  @override
  Future<void> setUnlockKey(List<int> value) async {
    logger.d('setUnlockKey');
    await _getSafeStorage().write(
      key: 'account::unlock_key',
      value: HEX.encode(value),
    );
  }

  @override
  Future<bool> getSettingsBiometricEnabled() async {
    logger.d('getSettingsBiometricEnabled');
    final value = await _getSafeStorage().read(
      key: 'settings::biometric_enabled',
    );
    return (value ?? 'false') == 'true';
  }

  @override
  Future<void> setSettingsBiometricEnabled(bool value) async {
    logger.d('setSettingsBiometricEnabled');
    await _getSafeStorage().write(
      key: 'settings::biometric_enabled',
      value: value ? 'true' : 'false',
    );
  }

  @override
  Future<Duration> getSettingsLockAfterDuration() async {
    logger.d('getSettingsLockAfterDuration');
    final value = await _getSafeStorage().read(
      key: 'settings::lock_after_duration',
    );
    return Duration(seconds: int.tryParse(value ?? '') ?? 30);
  }

  @override
  Future<void> setSettingsLockAfterDuration(Duration value) async {
    logger.d('setSettingsLockAfterDuration');
    await _getSafeStorage().write(
      key: 'settings::lock_after_duration',
      value: value.inSeconds.toString(),
    );
  }

  @override
  Future<void> setKek(SecretKey value) async {
    logger.d('setKek');
    try {
      final keyBytes = await value.extractBytes();
      _getCriticalStorage()?.write(
        key: 'account::kek',
        value: HEX.encode(keyBytes),
      );
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Future<SecretKey?> getKek() async {
    logger.d('getKek');
    try {
      final kekHex = await _getCriticalStorage()?.read(key: 'account::kek');
      if (kekHex == null) {
        return null;
      }
      final kekBytes = HEX.decode(kekHex);
      final kek = SecretKey(kekBytes);
      zeroing(kekBytes);
      return kek;
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  @override
  Future<void> flushAll() async {
    await _getSafeStorage().deleteAll();
    await _getCriticalStorage()?.deleteAll();
  }
}

late Store globalStore;

void initStore(Store s) {
  globalStore = s;
}

SecretKey? _globalKek;

void setGlobalKek(SecretKey kek) {
  logger.d('set global kek');
  _globalKek = kek;
}

void setGlobalTestKek() {
  logger.d('set global test kek');
  _globalKek = SecretKey(List.filled(32, 0));
}

SecretKey? getGlobalKek() {
  logger.d('get global test kek');
  return _globalKek;
}

void deleteGlobalKek() {
  logger.d('delete global kek');
  _globalKek = null;
}
