import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/helpers/sync.dart';
import 'package:mayflypass/secure/secure.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/database/database.dart';

part 'cubit.freezed.dart';

enum HomeStatus { loading, ready }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.loading) HomeStatus status,
    @Default([]) List<(String, Totp)> totps,
  }) = _HomeState;
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  Future<void> sync() async {
    emit(state.copyWith(status: .loading));
    await syncLocalAndRemote();
    await load();
  }

  Future<void> load() async {
    emit(state.copyWith(status: .loading));
    logger.d('loading entried from database');
    try {
      // get all entried from the database
      final entries = await gloablDB.selectLocalStorage(withDeleted: false);
      // for each entry, decrypt the payload and get
      // the Totp.
      final totps = await decryptEntries(entries);
      sortEntries(totps);
      emit(state.copyWith(totps: totps));
    } catch (e) {
      logger.e(e);
    } finally {
      emit(state.copyWith(status: .ready));
    }
  }

  void sortEntries(List<(String, Totp)> entries) {
    entries.sort((a, b) {
      var kA = '${a.$2.issuer}:${a.$2.account}';
      var kB = '${b.$2.issuer}:${b.$2.account}';
      return kA.compareTo(kB);
    });
  }

  Future<List<(String, Totp)>> decryptEntries(
    List<LocalStorageData> entries,
  ) async {
    final totps = <(String, Totp)>[];
    for (var entry in entries) {
      try {
        final databox = await decryptDataBox(
          getGlobalKek()!,
          entry.encryptedDek,
          entry.encryptedPayload,
        );
        totps.add((entry.id, databox.totp));
      } catch (e) {
        logger.e(e);
      }
    }
    return totps;
  }
}
