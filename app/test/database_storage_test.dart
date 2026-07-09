import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/database/helpers.dart';
import 'package:uuid/v7.dart';

AppDatabase openTestDatabase() => AppDatabase(NativeDatabase.memory());

void main() {
  late AppDatabase db;

  setUp(() {
    db = openTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('database storage', () {
    test('insert', () async {
      final input = LocalStorageData(
        id: UuidV7().generate(),
        updatedAtMs: generateVersion(),
        deleted: false,
        encryptedDek: Uint8List(0),
        encryptedPayload: Uint8List(0),
      );
      expect(await db.countStorage(), 0);
      await db.upsertLocalStorage(input);
      expect(await db.countStorage(), 1);
    });

    test('upsert', () async {
      var input = LocalStorageData(
        id: UuidV7().generate(),
        updatedAtMs: 1,
        deleted: false,
        encryptedDek: Uint8List(0),
        encryptedPayload: Uint8List(0),
      );
      await db.upsertLocalStorage(input);
      var row = await db.getStorage(input.id);
      expect(row!.updatedAtMs, 1);
      expect(row.encryptedDek.length, 0);
      expect(row.encryptedPayload.length, 0);
      // update the version
      input = input.copyWith(
        updatedAtMs: 2,
        encryptedDek: Uint8List(1),
        encryptedPayload: Uint8List(1),
      );
      await db.upsertLocalStorage(input);
      row = await db.getStorage(input.id);
      expect(row!.updatedAtMs, 2);
      expect(row.encryptedDek.length, 1);
      expect(row.encryptedPayload.length, 1);
      // update the version with lower value so the stored data shouldn't change
      input = input.copyWith(
        updatedAtMs: 1,
        encryptedDek: Uint8List(3),
        encryptedPayload: Uint8List(3),
      );
      await db.upsertLocalStorage(input);
      row = await db.getStorage(input.id);
      expect(row!.updatedAtMs, 2);
      expect(row.encryptedDek.length, 1);
      expect(row.encryptedPayload.length, 1);
    });
  });
}
