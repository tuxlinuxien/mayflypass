import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/secure/constants.dart';
import 'package:mayflypass/secure/secure.dart';

void main() {
  group('encryption', () {
    test('create new encryption key', () async {
      final key = newDataEncryptionKey();
      expect((await key.extractBytes()).length, secretKeyLength);
      final key2 = newDataEncryptionKey();
      expect((await key2.extractBytes()).length, secretKeyLength);
    });

    test('encrypt payload', () async {
      final masterKey = await deriveMasterPassword(32 * 1024, 3, 1, [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        0xa,
        0xb,
        0xc,
        0xd,
        0xe,
        0xf,
      ], 'password');
      final encrypted = await encrypt(masterKey, utf8.encode('01234567'));
      // xchacha20 nonce + payload + Poly
      expect(encrypted.toList().length, 24 + 8 + 16);
    });
  });

  test('decrypt payload', () async {
    final masterKey = newDataEncryptionKey();
    final encrypted = await encrypt(masterKey, utf8.encode('01234567'));
    final decrypted = await decrypt(masterKey, encrypted);
    expect(String.fromCharCodes(decrypted), '01234567');
  });

  test('decrypt wrong key', () async {
    final masterKey = SecretKey(List.filled(secretKeyLength, 0x0));
    final encrypted = await encrypt(masterKey, utf8.encode('01234567'));
    final invalidKey = SecretKey(List.filled(secretKeyLength, 0x1));
    try {
      await decrypt(invalidKey, encrypted);
      fail('should fail');
    } catch (e) {
      expect(true, e is SecretBoxAuthenticationError);
    }
  });

  test('decrypt wrong modified payload', () async {
    final masterKey = SecretKey(List.filled(secretKeyLength, 0x0));
    final encrypted = await encrypt(masterKey, utf8.encode('01234567'));
    encrypted[0] = 0xaa;
    try {
      await decrypt(masterKey, encrypted);
      fail('should fail');
    } catch (e) {
      expect(true, e is SecretBoxAuthenticationError);
    }
  });
}
