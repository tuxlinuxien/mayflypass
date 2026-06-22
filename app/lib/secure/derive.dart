import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:mayflypass/secure/constants.dart';

Future<SecretKey> deriveMasterPassword(
  int mem,
  int i,
  int p,
  List<int> salt,
  String password,
) async {
  final algorithm = Argon2id(
    memory: mem,
    iterations: i,
    parallelism: p,
    hashLength: secretKeyLength,
  );
  final newSecretKey = await algorithm.deriveKey(
    secretKey: SecretKey(utf8.encode(password)),
    nonce: salt,
  );
  final byteList = await newSecretKey.extractBytes();
  return SecretKey(byteList);
}
