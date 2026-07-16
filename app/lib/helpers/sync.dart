import 'package:mayflypass/api/api.dart';
import 'package:mayflypass/api/errors.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/core/logger.dart';
import 'package:mayflypass/database/database.dart';

Future<void> syncLocalAndRemote() async {
  {
    logger.i('get all entries from the database');
    final localEntries = await globalDB.selectLocalStorage();
    logger.i('local -> api ${localEntries.length}');
    final remoteEntries = localEntries
        .map(
          (entry) => ApiStorage(
            id: entry.id,
            updatedAtMs: entry.updatedAtMs,
            deleted: entry.deleted,
            encryptedDek: entry.encryptedDek,
            encryptedPayload: entry.encryptedPayload,
          ),
        )
        .toList();
    try {
      await API().storageUpsert(remoteEntries);
    } on ApiErrorNoNetwork {
      logger.i('no network');
    } on ApiError catch (e) {
      logger.e(e);
    }
  }

  {
    logger.i('get all entries from the api');
    try {
      final remoteEntries = await API().storageSelect();
      logger.i('api -> local ${remoteEntries.length}');
      for (final item in remoteEntries) {
        await globalDB.upsertLocalStorage(
          LocalStorageData(
            id: item.id,
            updatedAtMs: item.updatedAtMs,
            deleted: item.deleted,
            encryptedDek: item.encryptedDek,
            encryptedPayload: item.encryptedPayload,
          ),
        );
      }
    } catch (e) {
      logger.e(e);
    }
  }
  await globalStore.setLastSync();
}
