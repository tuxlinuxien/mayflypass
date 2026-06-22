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

AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) => AccountInfo(
  id: json['id'] as String,
  email: json['email'] as String,
  kekMCost: (json['kek_m_cost'] as num).toInt(),
  kekICost: (json['kek_i_cost'] as num).toInt(),
  kekPCost: (json['kek_p_cost'] as num).toInt(),
  kekSalt: const HexBytesConverter().fromJson(json['kek_salt'] as String),
);

Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'kek_m_cost': instance.kekMCost,
      'kek_i_cost': instance.kekICost,
      'kek_p_cost': instance.kekPCost,
      'kek_salt': const HexBytesConverter().toJson(instance.kekSalt),
    };

CaptchaResult _$CaptchaResultFromJson(Map<String, dynamic> json) =>
    CaptchaResult(id: json['id'] as String, image: json['image'] as String);

Map<String, dynamic> _$CaptchaResultToJson(CaptchaResult instance) =>
    <String, dynamic>{'id': instance.id, 'image': instance.image};

LoginInput _$LoginInputFromJson(Map<String, dynamic> json) => LoginInput(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginInputToJson(LoginInput instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

RegisterInput _$RegisterInputFromJson(Map<String, dynamic> json) =>
    RegisterInput(
      email: json['email'] as String,
      password: json['password'] as String,
      passwordRepeat: json['password_repeat'] as String,
      cId: json['c_id'] as String,
      cCode: json['c_code'] as String,
    );

Map<String, dynamic> _$RegisterInputToJson(RegisterInput instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'password_repeat': instance.passwordRepeat,
      'c_id': instance.cId,
      'c_code': instance.cCode,
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
  kekMCost: (json['kek_m_cost'] as num).toInt(),
  kekTCost: (json['kek_t_cost'] as num).toInt(),
  kekPCost: (json['kek_p_cost'] as num).toInt(),
  kekOutputLen: (json['kek_output_len'] as num).toInt(),
  kekSalt: (json['kek_salt'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'kek_m_cost': instance.kekMCost,
  'kek_t_cost': instance.kekTCost,
  'kek_p_cost': instance.kekPCost,
  'kek_output_len': instance.kekOutputLen,
  'kek_salt': instance.kekSalt,
};
