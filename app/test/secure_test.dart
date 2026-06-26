import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/secure/secure.dart';

void main() {
  group('derive', () {
    test('same master key after normalized emails', () async {
      final masterKey1 = await deriveMasterPassword(
        'test@mail.com',
        'password123',
      );
      final masterKey2 = await deriveMasterPassword(
        '  TEST@mail.com   ',
        'password123',
      );
      expect(await masterKey1.extractBytes(), await masterKey2.extractBytes());
      expect((await masterKey1.extractBytes()).length, 32);
      expect((await masterKey2.extractBytes()).length, 32);
    });

    test('build authentication key', () async {
      final masterKey = await deriveMasterPassword(
        'test@mail.com',
        'password123',
      );
      final authKey = await deriveAuthKey(masterKey);
      expect((await authKey.extractBytes()).length, 32);
      expect(
        true,
        (await authKey.extractBytes()) != (await masterKey.extractBytes()),
      );
    });

    test('build kek', () async {
      final masterKey = await deriveMasterPassword(
        'test@mail.com',
        'password123',
      );
      final kek = await deriveKek(masterKey);
      expect((await kek.extractBytes()).length, 32);
      expect(
        true,
        (await kek.extractBytes()) != (await masterKey.extractBytes()),
      );
    });

    test('compare authKey and kek are different', () async {
      final masterKey = await deriveMasterPassword(
        'test@mail.com',
        'password123',
      );
      final authKey = await deriveAuthKey(masterKey);
      final kek = await deriveKek(masterKey);
      expect((await authKey.extractBytes()).length, 32);
      expect((await kek.extractBytes()).length, 32);
      expect(
        true,
        (await authKey.extractBytes()) != (await kek.extractBytes()),
      );
    });

    test('secure constants params are unchanged', () async {
      final masterKey = await deriveMasterPassword(
        'test@mail.com',
        'password123',
      );
      final authKey = await deriveAuthKey(masterKey);
      final kek = await deriveKek(masterKey);

      expect((await masterKey.extractBytes()).length, 32);
      expect(
        base64.encode(await masterKey.extractBytes()),
        '4CPqxVgxbqu1uSEvP81uXjT4nFFGScoSH89824cTMXA=',
      );
      expect((await authKey.extractBytes()).length, 32);
      expect(
        base64.encode(await authKey.extractBytes()),
        'N0WKMoQeHY6Q3rqkLE33OLTYQcFU6NJ5cYFjRMN7CUM=',
      );
      expect((await kek.extractBytes()).length, 32);
      expect(
        base64.encode(await kek.extractBytes()),
        'K6HGUE+7HPHKgJFSlHd/Ixd2AjjzPYhN2i4JymiXMZ0=',
      );
    });
  });
}
