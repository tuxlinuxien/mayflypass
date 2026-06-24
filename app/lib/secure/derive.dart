import 'dart:convert';

import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:mayflypass/secure/constants.dart';

Future<SecretKey> deriveMasterPassword(String email, String password) async {
  // normalize the email since it will be the password salt.
  final normalizedEmail = email.toLowerCase().trim();
  // hash it with sha256 to get a 256 bits (32 bytes) salt.
  final emailHash = await Sha256().hash(utf8.encode(normalizedEmail));

  final algorithm = Argon2id(
    memory: masterPasswordMemCost,
    iterations: masterPasswordICost,
    parallelism: masterPasswordPCost,
    hashLength: secretKeyLength,
  );
  final newSecretKey = await algorithm.deriveKey(
    secretKey: SecretKey(utf8.encode(password)),
    nonce: emailHash.bytes,
  );
  final byteList = await newSecretKey.extractBytes();
  return SecretKey(byteList);
}

Future<SecretKey> deriveAuthKey(SecretKey masterKey) async {
  final hasher = Pbkdf2.hmacSha256(
    iterations: authIterations,
    bits: authBits, // 256 bits = 32 bytes
  );
  return await hasher.deriveKey(secretKey: masterKey, nonce: authSalt);
}

Future<SecretKey> deriveKek(SecretKey masterKey) async {
  final hasher = Pbkdf2.hmacSha256(
    iterations: kekIterations,
    bits: kekBits, // 256 bits = 32 bytes
  );
  return await hasher.deriveKey(secretKey: masterKey, nonce: kekSalt);
}
