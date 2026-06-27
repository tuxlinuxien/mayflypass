import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:mayflypass/api/models.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

@DriftDatabase(include: {'storage.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {},
  );

  Future<ApiStorage?> getStorage(UuidValue value) async {
    final row = await managers.storage
        .filter((t) => t.id.equals(value.uuid))
        .getSingleOrNull();
    if (row == null) return null;
    return ApiStorage(
      id: UuidValue.fromString(row.id),
      createdAt: row.createdAt.toUtc(),
      updatedAt: row.updatedAt.toUtc(),
      version: row.version,
      deleted: row.deleted,
      encryptedDek: row.encryptedDek,
      encryptedPayload: row.encryptedPayload,
    );
  }

  Future<List<ApiStorage>> selectStorage() async {
    final rows = await managers.storage.get();
    return rows.map((row) {
      return ApiStorage(
        id: UuidValue.fromString(row.id),
        createdAt: row.createdAt.toUtc(),
        updatedAt: row.updatedAt.toUtc(),
        version: row.version,
        deleted: row.deleted,
        encryptedDek: row.encryptedDek,
        encryptedPayload: row.encryptedPayload,
      );
    }).toList();
  }

  Future<int> countStorage() async {
    return managers.storage.count();
  }

  Future<void> upsertStorage(ApiStorage s) async {
    await customInsert(
      '''
      INSERT INTO storage
        (id, created_at, updated_at, version, deleted, encrypted_dek, encrypted_payload)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT (id) DO UPDATE SET
        updated_at        = excluded.updated_at,
        version           = excluded.version,
        deleted           = excluded.deleted,
        encrypted_dek     = excluded.encrypted_dek,
        encrypted_payload = excluded.encrypted_payload
      WHERE
        version < excluded.version
      ''',
      variables: [
        Variable.withString(s.id.uuid),
        Variable.withInt(s.createdAt.millisecondsSinceEpoch),
        Variable.withInt(s.updatedAt.millisecondsSinceEpoch),
        Variable.withInt(s.version),
        Variable.withBool(s.deleted),
        Variable.withBlob(s.encryptedDek),
        Variable.withBlob(s.encryptedPayload),
      ],
      updates: {storage},
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'mayflypass');
}
