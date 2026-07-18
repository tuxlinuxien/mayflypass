import 'dart:convert';
import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:mayflypass/secure/constants.dart';

Future<SecretKey> deriveMasterPassword(String username, String password) async {
  // normalize the username since it will be the password salt.
  final normalizedEmail = username.toLowerCase().trim();
  // hash it with sha256 to get a 256 bits (32 bytes) salt.
  final emailHash = await Sha256().hash(utf8.encode(normalizedEmail));

  final algorithm = Argon2id(
    memory: masterPasswordMemCost,
    iterations: masterPasswordICost,
    parallelism: masterPasswordPCost,
    hashLength: secretKeyLength,
  );
  return await algorithm.deriveKeyFromPassword(
    password: password,
    nonce: emailHash.bytes,
  );
}

Future<SecretKey> deriveAuthKey(SecretKey masterKey) async {
  final hasher = Hkdf(hmac: Hmac.sha256(), outputLength: authOutputLen);
  return await hasher.deriveKey(secretKey: masterKey, nonce: authSalt);
}

Future<SecretKey> deriveKek(SecretKey masterKey) async {
  final hasher = Hkdf(hmac: Hmac.sha256(), outputLength: kekOutputLen);
  return await hasher.deriveKey(secretKey: masterKey, nonce: kekSalt);
}

Future<SecretKey> deriveSessionKey(SecretKey masterKey) async {
  final hasher = Hkdf(hmac: Hmac.sha256(), outputLength: sessionOutputLen);
  return await hasher.deriveKey(secretKey: masterKey, nonce: sessionSalt);
}
