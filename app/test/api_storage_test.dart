import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/api/api.dart';
import 'package:mayflypass/core/core.dart';
import 'api_auth_test.dart';

void main() {
  initStore(MemoryStore());
  group('api storage', () {
    test('upsert', () async {
      await setupAccount();
      final input = ApiStorage.create(
        encryptedDek: Uint8List(0),
        encryptedPayload: Uint8List(0),
      );
      await API().storageUpsert(input);
      final response = await API().storageSelect();
      expect(response[0].id, input.id);
      expect(response[0].updatedAtMs, input.updatedAtMs);
      expect(response[0].deleted, input.deleted);
      expect(response[0].encryptedDek, input.encryptedDek);
      expect(response[0].encryptedPayload, input.encryptedPayload);
    });
  });
}
