// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncryptedStorage _$EncryptedStorageFromJson(Map<String, dynamic> json) =>
    EncryptedStorage(
      id: const UuidConverter().fromJson(json['id'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      version: (json['version'] as num).toInt(),
      deleted: json['deleted'] as bool,
      encryptedDek: const HexBytesConverter().fromJson(
        json['encrypted_dek'] as String,
      ),
      encryptedPayload: const HexBytesConverter().fromJson(
        json['encrypted_payload'] as String,
      ),
    );

Map<String, dynamic> _$EncryptedStorageToJson(EncryptedStorage instance) =>
    <String, dynamic>{
      'id': const UuidConverter().toJson(instance.id),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'version': instance.version,
      'deleted': instance.deleted,
      'encrypted_dek': const HexBytesConverter().toJson(instance.encryptedDek),
      'encrypted_payload': const HexBytesConverter().toJson(
        instance.encryptedPayload,
      ),
    };
