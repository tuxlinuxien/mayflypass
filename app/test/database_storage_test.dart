import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/database/database.dart';

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
    test('insert and select', () async {
      await db.into(db.storage).insert(StorageCompanion.insert(
            id: 'abc',
            accountId: 'account-1',
            version: 1,
            encryptedDek: Uint8List(0),
            encryptedPayload: Uint8List(0),
          ));

      final rows = await db.select(db.storage).get();
      expect(rows.length, 1);
      expect(rows.first.id, 'abc');
      expect(rows.first.accountId, 'account-1');
      expect(rows.first.version, 1);
      expect(rows.first.deleted, false);
    });

    test('select by account', () async {
      await db.into(db.storage).insert(StorageCompanion.insert(
            id: 'abc',
            accountId: 'account-1',
            version: 1,
            encryptedDek: Uint8List(0),
            encryptedPayload: Uint8List(0),
          ));
      await db.into(db.storage).insert(StorageCompanion.insert(
            id: 'xyz',
            accountId: 'account-2',
            version: 1,
            encryptedDek: Uint8List(0),
            encryptedPayload: Uint8List(0),
          ));

      final rows = await (db.select(db.storage)
            ..where((t) => t.accountId.equals('account-1')))
          .get();
      expect(rows.length, 1);
      expect(rows.first.id, 'abc');
    });

    test('soft delete', () async {
      await db.into(db.storage).insert(StorageCompanion.insert(
            id: 'abc',
            accountId: 'account-1',
            version: 1,
            encryptedDek: Uint8List(16),
            encryptedPayload: Uint8List(32),
          ));

      await (db.update(db.storage)
            ..where((t) => t.id.equals('abc') & t.accountId.equals('account-1')))
          .write(StorageCompanion(
            deleted: const Value(true),
            version: const Value(2),
            encryptedDek: Value(Uint8List(0)),
            encryptedPayload: Value(Uint8List(0)),
          ));

      final row = await (db.select(db.storage)
            ..where((t) => t.id.equals('abc')))
          .getSingle();
      expect(row.deleted, true);
      expect(row.version, 2);
      expect(row.encryptedDek, Uint8List(0));
      expect(row.encryptedPayload, Uint8List(0));
    });
  });
}
