import 'dart:typed_data';

import 'package:formz/formz.dart';
import 'package:mayflypass/api/api.dart';
import 'package:mayflypass/api/errors.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/forms/confirm_master_password.dart';
import 'package:mayflypass/forms/username.dart';
import 'package:mayflypass/forms/master_password.dart';
import 'package:mayflypass/secure/secure.dart';

part 'form_cubit.freezed.dart';

enum FormStatus { initial, submitting, success, failure }

@freezed
abstract class RegisterFormState with _$RegisterFormState {
  const factory RegisterFormState({
    @Default(UsernameValue.pure()) UsernameValue username,
    @Default(MasterPasswordValue.pure()) MasterPasswordValue masterPassword,
    @Default(ConfirmMasterPasswordValue.pure(''))
    ConfirmMasterPasswordValue confirmMasterPassword,
    @Default(FormStatus.initial) FormStatus status,
    ApiError? apiError,
    UsernameValueError? apiUsernameError,
  }) = _RegisterFormState;
}

class RegisterFormCubit extends Cubit<RegisterFormState> {
  RegisterFormCubit() : super(RegisterFormState());

  void usernameChanged(String value) {
    emit(
      state.copyWith(
        username: UsernameValue.dirty(value),
        apiUsernameError: null,
      ),
    );
  }

  void masterPasswordChanged(String value) {
    final confirm = state.confirmMasterPassword.isPure
        ? ConfirmMasterPasswordValue.pure(value)
        : ConfirmMasterPasswordValue.dirty(
            value,
            value: state.confirmMasterPassword.value,
          );
    emit(
      state.copyWith(
        masterPassword: MasterPasswordValue.dirty(value),
        confirmMasterPassword: confirm,
      ),
    );
  }

  void confirmMasterPasswordChanged(String value) {
    emit(
      state.copyWith(
        confirmMasterPassword: ConfirmMasterPasswordValue.dirty(
          state.masterPassword.value,
          value: value,
        ),
      ),
    );
  }

  Future<void> submit() async {
    final isValid = Formz.validate([
      state.username,
      state.masterPassword,
      state.confirmMasterPassword,
    ]);
    if (!isValid) return;

    // reset errors.
    emit(
      state.copyWith(
        status: FormStatus.submitting,
        apiError: null,
        apiUsernameError: null,
      ),
    );

    logger.i('derive auth password');
    // create auth key
    final masterKey = await deriveMasterPassword(
      state.username.value,
      state.masterPassword.value,
    );
    final authKey = await deriveAuthKey(masterKey);

    try {
      // get the challenge
      logger.i('fetch challenge');
      final challenge = await API().challenge();
      logger.i('solve challenge');
      final nonce = await challenge.solve();
      // register the account
      await API().register(
        RegisterInput(
          username: state.username.value,
          password: Uint8List.fromList(await authKey.extractBytes()),
          challengeKey: challenge.key,
          challengeNonce: nonce,
        ),
      );
    } on ApiErrorBadRequestWithFields catch (e) {
      for (final error in e.errors) {
        if (error.field == 'email') {
          switch (error) {
            case FieldErrorUsernameInvalid():
              emit(
                state.copyWith(apiUsernameError: UsernameValueInvalidError()),
              );
            case FieldErrorValueDuplicated():
              emit(
                state.copyWith(
                  apiUsernameError: UsernameValueDuplicatedError(),
                ),
              );
            default:
          }
        }
      }
      emit(state.copyWith(status: FormStatus.failure));
      return;
    } catch (e) {
      logger.e(e);
      emit(
        state.copyWith(status: FormStatus.failure, apiError: ApiErrorUnknown()),
      );
      return;
    } finally {
      masterKey.destroy();
      authKey.destroy();
    }

    emit(state.copyWith(status: FormStatus.success));
  }
}
