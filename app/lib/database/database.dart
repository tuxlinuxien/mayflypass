import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:fixnum/fixnum.dart';
import 'package:mayflypass/api/models.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/secure/encryption.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v7.dart';
import 'local_storage.dart';

part 'database.g.dart';

late final AppDatabase gloablDB;

void initDB([QueryExecutor? executor]) {
  gloablDB = AppDatabase(executor);
}

Future<void> initDBTestFixtures(SecretKey kek) async {
  var databox = DataBox.create();
  databox.totp = Totp(
    issuer: 'Issuer 1',
    account: 'yoann@mail.com',
    secret: 'AAAAAAAAAAAAAAAA',
    algorithm: TotpAlgorithm.SHA1,
    createdAtMs: Int64(DateTime.now().millisecondsSinceEpoch),
    digits: 6,
    period: 30,
    favorite: true,
    tags: [],
  );

  var (encryptedDek, encryptedPayload) = await encryptDataBox(kek, databox);
  await gloablDB.upsertLocalStorage(
    LocalStorageData(
      id: UuidV7().generate(),
      updatedAtMs: DateTime.now().millisecondsSinceEpoch,
      deleted: false,
      encryptedDek: encryptedDek,
      encryptedPayload: encryptedPayload,
    ),
  );

  databox = DataBox.create();
  databox.totp = Totp(
    issuer: 'Issuer 2',
    account: 'yoann@mail.com',
    secret: 'BBBBBBBBBBBBBBBB',
    algorithm: TotpAlgorithm.SHA1,
    createdAtMs: Int64(DateTime.now().millisecondsSinceEpoch),
    digits: 6,
    period: 60,
    favorite: false,
    tags: [],
  );

  (encryptedDek, encryptedPayload) = await encryptDataBox(kek, databox);
  await gloablDB.upsertLocalStorage(
    LocalStorageData(
      id: UuidV7().generate(),
      updatedAtMs: DateTime.now().millisecondsSinceEpoch,
      deleted: false,
      encryptedDek: encryptedDek,
      encryptedPayload: encryptedPayload,
    ),
  );
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

  Future<LocalStorageData?> getStorage(String id) async {
    return await managers.localStorage
        .filter((t) => t.id.equals(id))
        .getSingleOrNull();
  }

  Future<List<LocalStorageData>> selectStorage() async {
    return await managers.localStorage.get();
  }

  Future<int> countStorage() async {
    return managers.localStorage.count();
  }

  Future<void> upsertLocalStorage(LocalStorageData input) async {
    await into(localStorage).insert(
      LocalStorageCompanion.insert(
        id: input.id,
        updatedAtMs: input.updatedAtMs,
        deleted: input.deleted,
        encryptedDek: input.encryptedDek,
        encryptedPayload: input.encryptedPayload,
      ),
      onConflict: DoUpdate(
        (_) => LocalStorageCompanion(
          updatedAtMs: Value(input.updatedAtMs),
          deleted: Value(input.deleted),
          encryptedDek: Value(input.encryptedDek),
          encryptedPayload: Value(input.encryptedPayload),
        ),
        where: (old) =>
            localStorage.updatedAtMs.isSmallerThan(Variable(input.updatedAtMs)),
      ),
    );
  }

  Future<void> deleteStorage(String id) async {
    await upsertLocalStorage(
      LocalStorageData(
        id: id,
        updatedAtMs: DateTime.now().millisecondsSinceEpoch,
        deleted: true,
        encryptedDek: Uint8List(0),
        encryptedPayload: Uint8List(0),
      ),
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'mayflypass');
}

LocalStorageData localStorageDataFromApiStorage(ApiStorage api) {
  return LocalStorageData(
    id: api.id,
    deleted: api.deleted,
    updatedAtMs: api.updatedAtMs,
    encryptedDek: api.encryptedDek,
    encryptedPayload: api.encryptedPayload,
  );
}
