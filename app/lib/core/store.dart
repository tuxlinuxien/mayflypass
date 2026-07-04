import 'dart:io';

import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hex/hex.dart';
import 'package:mayflypass/core/logger.dart';
import 'package:mayflypass/secure/secure.dart';

abstract class Store {
  Future<String?> getApiRefreshToken();
  Future<void> setApiRefreshToken(String value);
  Future<void> deleteApiRefreshToken();

  Future<String?> getEmail();
  Future<void> setEmail(String value);

  Future<List<int>?> getUnlockKey();
  Future<void> setUnlockKey(List<int> value);

  Future<void> setKek(SecretKey value);
  Future<SecretKey?> getKek();

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
  Future<void> flushAll() async {}
}

class FSStore extends Store {
  FSStore();

  @override
  Future<String?> getApiRefreshToken() async {
    logger.d('getApiRefreshToken');
    return await FlutterSecureStorage().read(key: 'api::refresh_token');
  }

  @override
  Future<void> setApiRefreshToken(String value) async {
    logger.d('setApiRefreshToken');
    await FlutterSecureStorage().write(key: 'api::refresh_token', value: value);
  }

  @override
  Future<void> deleteApiRefreshToken() async {
    logger.d('deleteApiRefreshToken');
    await FlutterSecureStorage().delete(key: 'api::refresh_token');
  }

  @override
  Future<String?> getEmail() async {
    logger.d('getEmail');
    return await FlutterSecureStorage().read(key: 'account::email');
  }

  @override
  Future<void> setEmail(String value) async {
    logger.d('setEmail');
    await FlutterSecureStorage().write(key: 'account::email', value: value);
  }

  @override
  Future<List<int>?> getUnlockKey() async {
    logger.d('getUnlockKey');
    final value = await FlutterSecureStorage().read(key: 'account::unlock_key');
    if (value == null) {
      return null;
    }
    return HEX.decode(value);
  }

  @override
  Future<void> setUnlockKey(List<int> value) async {
    logger.d('setUnlockKey');
    await FlutterSecureStorage().write(
      key: 'account::unlock_key',
      value: HEX.encode(value),
    );
  }

  @override
  Future<void> setKek(SecretKey value) async {
    logger.d('setKek');
    try {
      if (!Platform.isAndroid && !Platform.isIOS) {
        return;
      }
      final keyBytes = await value.extractBytes();
      await FlutterSecureStorage().write(
        key: 'account::kek',
        value: HEX.encode(keyBytes),
        aOptions: AndroidOptions.biometric(
          enforceBiometrics: true,
          storageNamespace: 'critical',
          biometricType: AndroidBiometricType.strongBiometricOnly,
        ),
        iOptions: IOSOptions(useSecureEnclave: true, accountName: 'critical'),
      );
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Future<SecretKey?> getKek() async {
    logger.d('getKek');
    try {
      if (!Platform.isAndroid && !Platform.isIOS) {
        return null;
      }
      final kekHex = await FlutterSecureStorage().read(
        key: 'account::kek',
        aOptions: AndroidOptions.biometric(
          enforceBiometrics: true,
          storageNamespace: 'critical',
          biometricType: AndroidBiometricType.strongBiometricOnly,
        ),
        iOptions: IOSOptions(useSecureEnclave: true, accountName: 'critical'),
      );
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
    await FlutterSecureStorage().deleteAll();
  }
}

late Store globalStore;

void initStore(Store s) {
  globalStore = s;
}

SecretKey? _globalKek;

void setGlobalKek(SecretKey kek) {
  _globalKek = kek;
}

SecretKey? getGlobalKek() {
  return _globalKek;
}

void deleteGlobalKek() {
  _globalKek = null;
}
