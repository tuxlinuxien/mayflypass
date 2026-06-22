import 'package:json_annotation/json_annotation.dart';
import 'package:mayflypass/helpers/json.dart';

part 'models.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponse {
  final String accessToken;
  final String refreshToken;

  const LoginResponse({required this.accessToken, required this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RefreshResponse {
  final String accessToken;
  final String refreshToken;

  const RefreshResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountInfo {
  final String id;
  final String email;
  @JsonKey(name: 'kek_m_cost')
  final int kekMCost;
  @JsonKey(name: 'kek_i_cost')
  final int kekICost;
  @JsonKey(name: 'kek_p_cost')
  final int kekPCost;
  @JsonKey(name: 'kek_salt')
  @HexBytesConverter()
  final List<int> kekSalt;

  const AccountInfo({
    required this.id,
    required this.email,
    required this.kekMCost,
    required this.kekICost,
    required this.kekPCost,
    required this.kekSalt,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CaptchaResult {
  final String id;
  final String image;

  const CaptchaResult({required this.id, required this.image});

  factory CaptchaResult.fromJson(Map<String, dynamic> json) =>
      _$CaptchaResultFromJson(json);

  Map<String, dynamic> toJson() => _$CaptchaResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginInput {
  final String email;
  final String password;

  const LoginInput({required this.email, required this.password});

  factory LoginInput.fromJson(Map<String, dynamic> json) =>
      _$LoginInputFromJson(json);

  Map<String, dynamic> toJson() => _$LoginInputToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RegisterInput {
  final String email;
  final String password;
  final String passwordRepeat;
  @JsonKey(name: 'c_id')
  final String cId;
  @JsonKey(name: 'c_code')
  final String cCode;

  const RegisterInput({
    required this.email,
    required this.password,
    required this.passwordRepeat,
    required this.cId,
    required this.cCode,
  });

  factory RegisterInput.fromJson(Map<String, dynamic> json) =>
      _$RegisterInputFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterInputToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RefreshInput {
  final String? refreshToken;

  const RefreshInput({this.refreshToken});

  factory RefreshInput.fromJson(Map<String, dynamic> json) =>
      _$RefreshInputFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshInputToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LogoutInput {
  final String? refreshToken;

  const LogoutInput({this.refreshToken});

  factory LogoutInput.fromJson(Map<String, dynamic> json) =>
      _$LogoutInputFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutInputToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Account {
  final String id;
  final DateTime createdAt;
  @JsonKey(name: 'kek_m_cost')
  final int kekMCost;
  @JsonKey(name: 'kek_t_cost')
  final int kekTCost;
  @JsonKey(name: 'kek_p_cost')
  final int kekPCost;
  @JsonKey(name: 'kek_output_len')
  final int kekOutputLen;
  @JsonKey(name: 'kek_salt')
  final List<int> kekSalt;

  const Account({
    required this.id,
    required this.createdAt,
    required this.kekMCost,
    required this.kekTCost,
    required this.kekPCost,
    required this.kekOutputLen,
    required this.kekSalt,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
