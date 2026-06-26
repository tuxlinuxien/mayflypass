import 'dart:typed_data';
import 'package:cryptography_plus/cryptography_plus.dart';
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
  int genByte(int i) {
    return SecureRandom.safe.nextInt(1 << 8);
  }

  final newDek = List.generate(secretKeyLength, genByte);
  return SecretKey(newDek);
}
