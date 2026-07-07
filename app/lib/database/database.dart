import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:mayflypass/api/models.dart';
import 'package:uuid/uuid.dart';
import 'local_storage.dart';

part 'database.g.dart';

late final AppDatabase gloablDB;

void initDB([QueryExecutor? executor]) {
  gloablDB = AppDatabase(executor);
}

@DriftDatabase(tables: [LocalStorage])
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

  Future<LocalStorageData?> getStorage(UuidValue value) async {
    return await managers.localStorage
        .filter((t) => t.id.equals(value.uuid))
        .getSingleOrNull();
  }

  Future<List<LocalStorageData>> selectStorage() async {
    return await managers.localStorage.get();
  }

  Future<int> countStorage() async {
    return managers.localStorage.count();
  }

  Future<void> upsertStorage(ApiStorage value) async {
    final input = localStorageDataFromApiStorage(value);
    await into(localStorage).insert(
      LocalStorageCompanion.insert(
        id: input.id,
        version: input.version,
        deleted: input.deleted,
        encryptedDek: input.encryptedDek,
        encryptedPayload: input.encryptedPayload,
      ),
      onConflict: DoUpdate(
        (_) => LocalStorageCompanion(
          version: Value(input.version),
          deleted: Value(input.deleted),
          encryptedDek: Value(input.encryptedDek),
          encryptedPayload: Value(input.encryptedPayload),
        ),
        where: (old) =>
            localStorage.version.isSmallerThan(Variable(input.version)),
      ),
    );
  }

  Future<void> upsert(LocalStorageData input) async {
    await into(localStorage).insert(
      LocalStorageCompanion.insert(
        id: input.id,
        version: input.version,
        deleted: input.deleted,
        encryptedDek: input.encryptedDek,
        encryptedPayload: input.encryptedPayload,
      ),
      onConflict: DoUpdate(
        (_) => LocalStorageCompanion(
          version: Value(input.version),
          deleted: Value(input.deleted),
          encryptedDek: Value(input.encryptedDek),
          encryptedPayload: Value(input.encryptedPayload),
        ),
        where: (old) =>
            localStorage.version.isSmallerThan(Variable(input.version)),
      ),
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'mayflypass');
}

LocalStorageData localStorageDataFromApiStorage(ApiStorage api) {
  return LocalStorageData(
    id: Uuid.unparse(api.id.toBytes()),
    deleted: api.deleted,
    version: api.version,
    encryptedDek: api.encryptedDek,
    encryptedPayload: api.encryptedPayload,
  );
}
