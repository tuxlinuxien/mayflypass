import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String?> StorageGetApiRefreshToken() async {
  const store = FlutterSecureStorage(lOptions: LinuxOptions());
  return await store.read(key: 'api::refreshToken');
}

Future<void> StorageSetApiRefreshToken(String token) async {
  const store = FlutterSecureStorage(lOptions: LinuxOptions());
  await store.write(key: 'api::refreshToken', value: token);
}

Future<String?> StorageGetAccount() async {
  const store = FlutterSecureStorage(lOptions: LinuxOptions());
  return await store.read(key: 'account::email');
}

Future<void> StorageSetAccount(String email) async {
  const store = FlutterSecureStorage(lOptions: LinuxOptions());
  await store.write(key: 'account::email', value: email);
}
