import 'package:json_annotation/json_annotation.dart';

class HexBytesConverter implements JsonConverter<List<int>, String> {
  const HexBytesConverter();

  @override
  List<int> fromJson(String hex) {
    final cleaned = hex
        .replaceAll('0x', '')
        .replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
    return List<int>.generate(
      cleaned.length ~/ 2,
      (i) => int.parse(cleaned.substring(i * 2, i * 2 + 2), radix: 16),
    );
  }

  @override
  String toJson(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
