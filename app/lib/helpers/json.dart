import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

class HexBytesConverter implements JsonConverter<Uint8List, String> {
  const HexBytesConverter();

  @override
  Uint8List fromJson(String hex) => Uint8List.fromList(HEX.decode(hex));

  @override
  String toJson(Uint8List bytes) => HEX.encode(bytes.toList());
}

class UuidConverter implements JsonConverter<UuidValue, String> {
  const UuidConverter();

  @override
  UuidValue fromJson(String json) => UuidValue.fromString(json);

  @override
  String toJson(UuidValue uuid) => uuid.toString();
}
