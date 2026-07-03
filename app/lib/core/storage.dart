import 'package:biometric_storage/biometric_storage.dart';
import 'package:hex/hex.dart';
import 'package:mayflypass/core/logger.dart';

abstract class Storage {
  Future<String?> getApiRefreshToken();
  Future<void> setApiRefreshToken(String value);
  Future<void> deleteApiRefreshToken();

  Future<String?> getEmail();
  Future<void> setEmail(String value);

  Future<List<int>?> getUnlockKey();
  Future<void> setUnlockKey(List<int> value);
}

class StorageTest extends Storage {
  final values = <String, dynamic>{};

  StorageTest();

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
}

class StorageEncrypted extends Storage {
  StorageEncrypted();

  @override
  Future<String?> getApiRefreshToken() async {
    logger.d('getApiRefreshToken');
    final store = await BiometricStorage().getStorage('api::refresh_token');
    return store.read();
  }

  @override
  Future<void> setApiRefreshToken(String value) async {
    logger.d('setApiRefreshToken');
    final store = await BiometricStorage().getStorage('api::refresh_token');
    await store.write(value);
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
    final store = await BiometricStorage().getStorage('account::email');
    return await store.read();
  }

  @override
  Future<void> setEmail(String value) async {
    logger.d('setEmail');
    final store = await BiometricStorage().getStorage('account::email');
    await store.write(value);
  }

  @override
  Future<List<int>?> getUnlockKey() async {
    logger.d('getUnlockKey');
    final store = await BiometricStorage().getStorage('account::unlock_key');
    final value = await store.read();
    if (value == null) {
      return null;
    }
    return HEX.decode(value);
  }

  @override
  Future<void> setUnlockKey(List<int> value) async {
    logger.d('setUnlockKey');
    final store = await BiometricStorage().getStorage('account::unlock_key');
    await store.write(HEX.encode(value));
  }
}

late Storage storage;

void initSecureStorage(Storage s) {
  storage = s;
}
