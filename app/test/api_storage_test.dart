import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/api/api.dart';
import 'api_auth_test.dart';

void main() {
  group('api storage', () {
    test('upsert', () async {
      await setupAccount();
      final input = ApiStorage.create(
        encryptedDek: Uint8List(0),
        encryptedPayload: Uint8List(0),
      );
      final response = await API().storageUpsert(input);
      expect(response.id, input.id);
      expect(response.version, input.version);
      expect(response.deleted, input.deleted);
      expect(response.encryptedDek, input.encryptedDek);
      expect(response.encryptedPayload, input.encryptedPayload);
    });
  });
}
