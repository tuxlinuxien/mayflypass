import 'package:mayflypass/api/api.dart';
import 'package:mayflypass/api/errors.dart';
import 'package:mayflypass/core/logger.dart';
import 'package:mayflypass/database/database.dart';

Future<void> syncLocalAndRemote() async {
  logger.i('get all entries from the database');
  final localEntries = await gloablDB.selectStorage();
  for (final item in localEntries) {
    try {
      logger.i('local -> api ${item.id}');
      await API().storageUpsert(
        ApiStorage(
          id: item.id,
          updatedAtMs: item.updatedAtMs,
          deleted: item.deleted,
          encryptedDek: item.encryptedDek,
          encryptedPayload: item.encryptedPayload,
        ),
      );
    } on ApiErrorNoNetwork {
      logger.i('no network');
      continue;
    } on ApiError catch (e) {
      logger.e(e);
    }
  }
  logger.i('get all entries from the api');
  try {
    final remoteEntries = await API().storageSelect();
    for (final item in remoteEntries) {
      logger.i('api -> local ${item.id}');
      await gloablDB.upsertLocalStorage(
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
