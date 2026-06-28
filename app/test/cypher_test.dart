import 'dart:convert';
import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/secure/constants.dart';
import 'package:mayflypass/secure/secure.dart';

void main() {
  group('cypher', () {
    test('create new encryption key', () async {
      final key = newDataEncryptionKey();
      expect((await key.extractBytes()).length, secretKeyLength);
      final key2 = newDataEncryptionKey();
      expect((await key2.extractBytes()).length, secretKeyLength);
    });

    test('encrypt payload', () async {
      final masterKey = await deriveMasterPassword('test@mail.com', '12345678');
      final kek = await deriveKek(masterKey);
      final encrypted = await encrypt(kek, utf8.encode('01234567'));
      // xchacha20 nonce + payload + Poly
      expect(encrypted.toList().length, 24 + 8 + 16);
    });
  });

  test('decrypt payload', () async {
    final masterKey = await deriveMasterPassword('test@mail.com', '12345678');
    final kek = await deriveKek(masterKey);
    final encrypted = await encrypt(kek, utf8.encode('01234567'));
    final decrypted = await decrypt(kek, encrypted);
    expect(String.fromCharCodes(decrypted), '01234567');
  });

  test('decrypt wrong key', () async {
    final masterKey = await deriveMasterPassword('test@mail.com', '12345678');
    final kek = await deriveKek(masterKey);
    final encrypted = await encrypt(kek, utf8.encode('01234567'));
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

  test('encrypt/decrypt databox', () async {
    final totp = Totp(
      issuer: 'mayflypass.com',
      account: 'yoann@mail.com',
      secret: '0123456789ABCDEF',
      algorithm: TotpAlgorithm.SHA256,
      digits: 8,
      period: 60,
      createdAtMs: Int64(DateTime.now().millisecondsSinceEpoch),
    );
    final databox = DataBox(totp: totp);
    final masterKey = await deriveMasterPassword('test@mail.com', '12345678');
    final kek = await deriveKek(masterKey);
    final (encDek, encPld) = await encryptDataBox(kek, databox);
    final decDatabox = await decryptDataBox(kek, encDek, encPld);
    expect(decDatabox.writeToBuffer(), databox.writeToBuffer());
  });
}
