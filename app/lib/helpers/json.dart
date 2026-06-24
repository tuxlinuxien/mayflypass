import 'package:hex/hex.dart';
import 'package:json_annotation/json_annotation.dart';

class HexBytesConverter implements JsonConverter<List<int>, String> {
  const HexBytesConverter();

  @override
  List<int> fromJson(String hex) => HEX.decode(hex);

  @override
  String toJson(List<int> bytes) => HEX.encode(bytes);
}
