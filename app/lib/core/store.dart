import 'package:biometric_storage/biometric_storage.dart';
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
    final store = await BiometricStorage().getStorage('api::refresh_token');
    await store.delete();
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
      final bs = await BiometricStorage().getStorage('account::kek');
      final keyBytes = await value.extractBytes();
      await bs.write(HEX.encode(keyBytes));
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Future<SecretKey?> getKek() async {
    logger.d('get');
    try {
      final bs = await BiometricStorage().getStorage('account::kek');
      final kekHex = await bs.read();
      if (kekHex == null) {
        return null;
      }
      final kekBytes = HEX.decode(kekHex);
      final kek = SecretKey(kekBytes);
      zeroing(kekBytes);
      return kek;
    } catch (e) {
      return null;
    }
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
