import 'package:fixnum/fixnum.dart';
import 'package:formz/formz.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/databox/databox.dart';
import 'package:mayflypass/forms/totp_account.dart';
import 'package:mayflypass/forms/totp_issuer.dart';
import 'package:mayflypass/forms/totp_secret.dart';
import 'package:mayflypass/secure/secure.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v7.dart';

part 'cubit.freezed.dart';

enum TotpStatus { loading, ready, success, failure }

@freezed
abstract class TotpState with _$TotpState {
  const factory TotpState({
    @Default(TotpStatus.loading) TotpStatus status,
    required UuidValue id,
    required int createdAtMs,
    @Default(TotpIssuerValue.pure()) TotpIssuerValue issuer,
    @Default(TotpAccountValue.pure()) TotpAccountValue account,
    @Default(TotpSecretValue.pure()) TotpSecretValue secret,
    @Default(TotpAlgorithm.SHA1) TotpAlgorithm algorithm,
    @Default(6) int digits,
    @Default(30) int period,
    @Default(false) bool favorite,
    @Default([]) List<String> tags,
  }) = _TotpState;

  factory TotpState.init() {
    final newId = UuidValue.fromString(UuidV7().generate());

    return TotpState(
      id: newId,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class TotpCubit extends Cubit<TotpState> {
  TotpCubit() : super(TotpState.init());

  Future<void> load(UuidValue? id) async {
    logger.w('with id: $id');
    if (id == null) {
      emit(state.copyWith(status: .ready));
      return;
    }
    final entry = await gloablDB.getStorage(id);
    if (entry == null) {
      emit(state.copyWith(status: .ready));
      return;
    }
    try {
      final dbox = await decryptDataBox(
        getGlobalKek()!,
        entry.encryptedDek,
        entry.encryptedPayload,
      );
      emit(
        state.copyWith(
          id: id,
          issuer: TotpIssuerValue.dirty(dbox.totp.issuer),
          account: TotpAccountValue.dirty(dbox.totp.account),
          secret: TotpSecretValue.dirty(dbox.totp.secret),
          algorithm: dbox.totp.algorithm,
          digits: dbox.totp.digits,
          period: dbox.totp.period,
          favorite: dbox.totp.favorite,
          tags: dbox.totp.tags,
        ),
      );
      logger.i('totp entry loaded');
    } catch (e) {
      logger.e(e);
    } finally {
      emit(state.copyWith(status: .ready));
    }
  }

  void changeIssuer(String value) {
    emit(
      state.copyWith(
        status: .ready,
        issuer: TotpIssuerValue.dirty(value.trim()),
      ),
    );
  }

  void changeAccount(String value) {
    emit(
      state.copyWith(
        status: .ready,
        account: TotpAccountValue.dirty(value.trim()),
      ),
    );
  }

  void changeSecret(String value) {
    emit(
      state.copyWith(
        status: .ready,
        secret: TotpSecretValue.dirty(value.trim()),
      ),
    );
  }

  void changeAlgorithm(TotpAlgorithm? value) {
    emit(
      state.copyWith(status: .ready, algorithm: value ?? TotpAlgorithm.SHA1),
    );
  }

  void changeDigits(int? value) {
    emit(state.copyWith(status: .ready, digits: value ?? 6));
  }

  void changePeriod(int? value) {
    emit(state.copyWith(status: .ready, period: value ?? 30));
  }

  void changeFavorite(bool? value) {
    emit(state.copyWith(status: .ready, favorite: value ?? false));
  }

  void changeTags(String value) {
    var tags = value.trim().split(',');
    tags = tags.map((tag) => tag.trim()).toList();
    tags.removeWhere((tag) => tag.isEmpty);
    emit(state.copyWith(status: .ready, tags: tags));
  }

  Future<bool> submit() async {
    final isValid = Formz.validate([state.issuer, state.account, state.secret]);
    if (!isValid) {
      return false;
    }

    final databox = DataBox(
      totp: Totp(
        issuer: state.issuer.value.trim(),
        account: state.account.value.trim(),
        secret: state.secret.value.trim(),
        algorithm: state.algorithm,
        createdAtMs: Int64(state.createdAtMs),
        digits: state.digits,
        period: state.period,
        favorite: state.favorite,
        tags: state.tags,
      ),
    );

    if (getGlobalKek() == null) {
      logger.e('kek is missing');
      globalAuth.lock();
      return false;
    }

    final (encryptedDek, encryptedPayload) = await encryptDataBox(
      getGlobalKek()!,
      databox,
    );

    final entry = LocalStorageData(
      id: Uuid.unparse(state.id.toBytes()),
      version: DateTime.now().millisecondsSinceEpoch,
      deleted: false,
      encryptedDek: encryptedDek,
      encryptedPayload: encryptedPayload,
    );

    logger.i('upsert into database...');
    await gloablDB.upsert(entry);
    logger.i('upsered [OK]');

    emit(state.copyWith(status: .success));
    return true;
  }
}
