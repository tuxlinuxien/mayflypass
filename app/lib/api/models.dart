import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:mayflypass/helpers/json.dart';
import 'package:uuid/uuid.dart';

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

  const AccountInfo({required this.id, required this.email});

  factory AccountInfo.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ChallengeResult {
  @HexBytesConverter()
  final Uint8List key;
  @HexBytesConverter()
  final Uint8List salt;
  @HexBytesConverter()
  final Uint8List difficulty;

  const ChallengeResult({
    required this.key,
    required this.salt,
    required this.difficulty,
  });

  factory ChallengeResult.fromJson(Map<String, dynamic> json) =>
      _$ChallengeResultFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeResultToJson(this);

  Future<int> solve() async {
    return await compute(_solveChallenge, (key, salt, difficulty));
  }

  static Future<int> _solveChallenge(
    (Uint8List, Uint8List, Uint8List) input,
  ) async {
    final key = input.$1;
    final salt = input.$2;
    final target = input.$3;
    final hasher = Sha256();
    final nonceBytes = ByteData(8);

    for (var nonce = 0; nonce < 0x7FFFFFFFFFFFFFFF; nonce++) {
      nonceBytes.setInt64(0, nonce, Endian.little);
      final inputBytes = Uint8List.fromList([
        ...key,
        ...salt,
        ...nonceBytes.buffer.asUint8List(),
      ]);
      final hash = await hasher.hash(inputBytes);
      if (_checkHashes(hash.bytes, target)) {
        return nonce;
      }
    }
    return -1;
  }

  static bool _checkHashes(List<int> hash, List<int> target) {
    if (hash.length != target.length) {
      return false;
    }
    for (var i = 0; i < hash.length; i++) {
      if (hash[i] > target[i]) return false;
      if (hash[i] < target[i]) return true;
    }
    return true;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginInput {
  final String email;
  @HexBytesConverter()
  final Uint8List password;

  const LoginInput({required this.email, required this.password});

  factory LoginInput.fromJson(Map<String, dynamic> json) =>
      _$LoginInputFromJson(json);

  Map<String, dynamic> toJson() => _$LoginInputToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RegisterInput {
  final String email;
  @HexBytesConverter()
  final Uint8List password;
  @HexBytesConverter()
  final Uint8List challengeKey;
  final int challengeNonce;

  const RegisterInput({
    required this.email,
    required this.password,
    required this.challengeKey,
    required this.challengeNonce,
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

  const Account({required this.id, required this.createdAt});

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Storage {
  @UuidConverter()
  final UuidValue id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool deleted;
  @JsonKey(name: 'encrypted_dek')
  @HexBytesConverter()
  final Uint8List encryptedDek;
  @JsonKey(name: 'encrypted_payload')
  @HexBytesConverter()
  final Uint8List encryptedPayload;

  const Storage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.deleted,
    required this.encryptedDek,
    required this.encryptedPayload,
  });

  factory Storage.fromJson(Map<String, dynamic> json) =>
      _$StorageFromJson(json);

  Map<String, dynamic> toJson() => _$StorageToJson(this);
}
