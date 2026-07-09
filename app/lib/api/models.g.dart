// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };

RefreshResponse _$RefreshResponseFromJson(Map<String, dynamic> json) =>
    RefreshResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$RefreshResponseToJson(RefreshResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };

AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) =>
    AccountInfo(id: json['id'] as String, email: json['email'] as String);

Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
    <String, dynamic>{'id': instance.id, 'email': instance.email};

ChallengeResult _$ChallengeResultFromJson(Map<String, dynamic> json) =>
    ChallengeResult(
      key: const HexBytesConverter().fromJson(json['key'] as String),
      salt: const HexBytesConverter().fromJson(json['salt'] as String),
      difficulty: const HexBytesConverter().fromJson(
        json['difficulty'] as String,
      ),
    );

Map<String, dynamic> _$ChallengeResultToJson(ChallengeResult instance) =>
    <String, dynamic>{
      'key': const HexBytesConverter().toJson(instance.key),
      'salt': const HexBytesConverter().toJson(instance.salt),
      'difficulty': const HexBytesConverter().toJson(instance.difficulty),
    };

LoginInput _$LoginInputFromJson(Map<String, dynamic> json) => LoginInput(
  email: json['email'] as String,
  password: const HexBytesConverter().fromJson(json['password'] as String),
);

Map<String, dynamic> _$LoginInputToJson(LoginInput instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': const HexBytesConverter().toJson(instance.password),
    };

RegisterInput _$RegisterInputFromJson(Map<String, dynamic> json) =>
    RegisterInput(
      email: json['email'] as String,
      password: const HexBytesConverter().fromJson(json['password'] as String),
      challengeKey: const HexBytesConverter().fromJson(
        json['challenge_key'] as String,
      ),
      challengeNonce: (json['challenge_nonce'] as num).toInt(),
    );

Map<String, dynamic> _$RegisterInputToJson(RegisterInput instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': const HexBytesConverter().toJson(instance.password),
      'challenge_key': const HexBytesConverter().toJson(instance.challengeKey),
      'challenge_nonce': instance.challengeNonce,
    };

RefreshInput _$RefreshInputFromJson(Map<String, dynamic> json) =>
    RefreshInput(refreshToken: json['refresh_token'] as String?);

Map<String, dynamic> _$RefreshInputToJson(RefreshInput instance) =>
    <String, dynamic>{'refresh_token': instance.refreshToken};

LogoutInput _$LogoutInputFromJson(Map<String, dynamic> json) =>
    LogoutInput(refreshToken: json['refresh_token'] as String?);

Map<String, dynamic> _$LogoutInputToJson(LogoutInput instance) =>
    <String, dynamic>{'refresh_token': instance.refreshToken};

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
};

ApiStorage _$ApiStorageFromJson(Map<String, dynamic> json) => ApiStorage(
  id: json['id'] as String,
  updatedAtMs: (json['updated_at_ms'] as num).toInt(),
  deleted: json['deleted'] as bool,
  encryptedDek: const HexBytesConverter().fromJson(
    json['encrypted_dek'] as String,
  ),
  encryptedPayload: const HexBytesConverter().fromJson(
    json['encrypted_payload'] as String,
  ),
);

Map<String, dynamic> _$ApiStorageToJson(ApiStorage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updated_at_ms': instance.updatedAtMs,
      'deleted': instance.deleted,
      'encrypted_dek': const HexBytesConverter().toJson(instance.encryptedDek),
      'encrypted_payload': const HexBytesConverter().toJson(
        instance.encryptedPayload,
      ),
    };
