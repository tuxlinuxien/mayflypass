import 'dart:typed_data';
import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/secure/constants.dart';

Future<Uint8List> encrypt(SecretKey key, Uint8List clearText) async {
  final e = Xchacha20.poly1305Aead();
  final nonce = e.newNonce();
  final encryptedBuffer = await e.encrypt(
    clearText,
    secretKey: key,
    nonce: nonce,
  );
  return encryptedBuffer.concatenation(nonce: true, mac: true);
}

Future<Uint8List> decrypt(SecretKey key, Uint8List encryptedText) async {
  final e = Xchacha20.poly1305Aead();
  final box = SecretBox.fromConcatenation(
    encryptedText,
    nonceLength: e.nonceLength,
    macLength: Poly1305().macLength,
  );
  final data = await e.decrypt(box, secretKey: key);
  return Uint8List.fromList(data);
}

SecretKey newDataEncryptionKey() {
  return SecretKeyData.random(length: secretKeyLength);
}

Future<DataBox> decryptDataBox(
  SecretKey kek,
  Uint8List encryptedDek,
  Uint8List encryptedPayload,
) async {
  final dekBytes = await decrypt(kek, encryptedDek);
  final dek = SecretKey(dekBytes.toList());
  dekBytes.fillRange(0, dekBytes.length, 0); // clean bytes
  final payload = await decrypt(dek, encryptedPayload);
  dek.destroy();
  return DataBox.fromBuffer(payload);
}

Future<(Uint8List, Uint8List)> encryptDataBox(
  SecretKey kek,
  DataBox databox,
) async {
  final dek = newDataEncryptionKey();
  final dekBytes = Uint8List.fromList(await dek.extractBytes());
  final encryptedDek = await encrypt(kek, dekBytes);
  dekBytes.fillRange(0, dekBytes.length, 0); // clean bytes
  final encryptedPayload = await encrypt(dek, databox.writeToBuffer());
  dek.destroy();
  return (encryptedDek, encryptedPayload);
}
