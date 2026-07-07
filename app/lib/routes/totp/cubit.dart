import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/forms/totp_account.dart';
import 'package:mayflypass/forms/totp_issuer.dart';
import 'package:mayflypass/forms/totp_secret.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v7.dart';

part 'cubit.freezed.dart';

enum TotpStatus { loading, ready }

@freezed
abstract class TotpState with _$TotpState {
  const factory TotpState({
    @Default(TotpStatus.loading) TotpStatus status,
    required UuidValue id,
    @Default(TotpIssuerValue.pure()) TotpIssuerValue issuer,
    @Default(TotpAccountValue.pure()) TotpAccountValue account,
    @Default(TotpSecretValue.pure()) TotpSecretValue secret,
  }) = _TotpState;

  factory TotpState.init() {
    final newId = UuidValue.fromString(UuidV7().generate());
    return TotpState(id: newId);
  }
}

class TotpCubit extends Cubit<TotpState> {
  TotpCubit() : super(TotpState.init());

  Future<void> load(UuidValue? id) async {
    if (id == null) {
      emit(state.copyWith(status: TotpStatus.ready));
      return;
    }
  }
}
