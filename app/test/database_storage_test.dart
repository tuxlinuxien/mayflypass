import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/api/api.dart';

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
      final input = ApiStorage.create(
        encryptedDek: Uint8List(0),
        encryptedPayload: Uint8List(0),
      );
      expect(await db.countStorage(), 0);
      await db.upsertStorage(input);
      expect(await db.countStorage(), 1);
    });

    test('upsert', () async {
      final input = ApiStorage.create(
        encryptedDek: Uint8List(0),
        encryptedPayload: Uint8List(0),
      )..version = 1;
      await db.upsertStorage(input);
      var row = await db.getStorage(input.id);
      expect(row!.version, 1);
      expect(row.encryptedDek.length, 0);
      expect(row.encryptedPayload.length, 0);
      // update the version
      input.version = 2;
      input.encryptedDek = Uint8List(1);
      input.encryptedPayload = Uint8List(1);
      await db.upsertStorage(input);
      row = await db.getStorage(input.id);
      expect(row!.version, 2);
      expect(row.encryptedDek.length, 1);
      expect(row.encryptedPayload.length, 1);
      // update the version with lower value so the stored data shouldn't chage
      input.version = 1;
      input.encryptedDek = Uint8List(3);
      input.encryptedPayload = Uint8List(3);
      await db.upsertStorage(input);
      row = await db.getStorage(input.id);
      expect(row!.version, 2);
      expect(row.encryptedDek.length, 1);
      expect(row.encryptedPayload.length, 1);
    });
  });
}
