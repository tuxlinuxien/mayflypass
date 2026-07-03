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

late Storage storage;

void initSecureStorage(Storage s) {
  storage = s;
}
