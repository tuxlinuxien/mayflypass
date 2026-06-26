import 'package:json_annotation/json_annotation.dart';
import 'package:mayflypass/helpers/json.dart';
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
  @JsonKey(name: 'encrypted_kek')
  @HexBytesConverter()
  final List<int> encryptedKek;
  @JsonKey(name: 'encrypted_payload')
  @HexBytesConverter()
  final List<int> encryptedPayload;

  const EncryptedStorage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.deleted,
    required this.encryptedKek,
    required this.encryptedPayload,
  });

  factory EncryptedStorage.fromJson(Map<String, dynamic> json) =>
      _$EncryptedStorageFromJson(json);

  Map<String, dynamic> toJson() => _$EncryptedStorageToJson(this);
}

class DecryptedStorage {
  final UuidValue id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool deleted;
  final DataBox databox;

  const DecryptedStorage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.deleted,
    required this.databox,
  });
}
