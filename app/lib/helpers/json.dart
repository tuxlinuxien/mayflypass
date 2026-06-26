import 'package:hex/hex.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

class HexBytesConverter implements JsonConverter<List<int>, String> {
  const HexBytesConverter();

  @override
  List<int> fromJson(String hex) => HEX.decode(hex);

  @override
  String toJson(List<int> bytes) => HEX.encode(bytes);
}

class UuidConverter implements JsonConverter<UuidValue, String> {
  const UuidConverter();

  @override
  UuidValue fromJson(String json) => UuidValue.fromString(json);

  @override
  String toJson(UuidValue uuid) => uuid.toString();
}
