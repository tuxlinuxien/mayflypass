import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mayflypass/helpers/json.dart';
import 'package:mayflypass/secure/encryption.dart';
import 'package:mayflypass/storage/databox.pb.dart';
import 'package:uuid/uuid.dart';

export 'package:mayflypass/storage/databox.pb.dart';

part 'storage.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EncryptedStorage {
  @UuidConverter()
  final UuidValue id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool deleted;
  @JsonKey(name: 'encrypted_dek')
  @HexBytesConverter()
  final List<int> encryptedDek;
  @JsonKey(name: 'encrypted_payload')
  @HexBytesConverter()
  final List<int> encryptedPayload;

  const EncryptedStorage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.deleted,
    required this.encryptedDek,
    required this.encryptedPayload,
  });

  factory EncryptedStorage.fromJson(Map<String, dynamic> json) =>
      _$EncryptedStorageFromJson(json);

  Map<String, dynamic> toJson() => _$EncryptedStorageToJson(this);

  Future<DataBox> decryptDataBox(SecretKey kek) async {
    // decrypt the data encryption key
    final encryptedDekBuffer = Uint8List.fromList(encryptedDek);
    final dek = await decrypt(kek, encryptedDekBuffer);

    // decrypt the payload
    final encryptedPayloadBuffer = Uint8List.fromList(encryptedPayload);
    final dataBoxBuffer = await decrypt(SecretKey(dek), encryptedPayloadBuffer);
    return DataBox.fromBuffer(dataBoxBuffer);
  }
}

class Storage {
  UuidValue id;
  DateTime createdAt;
  DateTime updatedAt;
  int version;
  bool deleted;
  DataBox databox;

  Storage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.deleted,
    required this.databox,
  });

  Future<EncryptedStorage> toEncryptedStorage(SecretKey kek) async {
    final newDek = newDataEncryptionKey();
    final dataBoxBytes = databox.writeToBuffer();
    final newDekBytes = Uint8List.fromList(await newDek.extractBytes());

    return EncryptedStorage(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      version: version,
      deleted: deleted,
      encryptedDek: await encrypt(kek, newDekBytes),
      encryptedPayload: await encrypt(newDek, dataBoxBytes),
    );
  }
}
