import 'dart:typed_data';

import 'package:formz/formz.dart';
import 'package:mayflypass/api/api.dart';
import 'package:mayflypass/api/errors.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/database/helpers.dart';
import 'package:mayflypass/forms/confirm_master_password.dart';
import 'package:mayflypass/forms/master_password.dart';
import 'package:mayflypass/helpers/sync.dart';
import 'package:mayflypass/secure/secure.dart';

part 'cubit.freezed.dart';

enum ChangePasswordStatus { ready, submitting, success, failure }

@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default(ChangePasswordStatus.ready) ChangePasswordStatus status,
    @Default(MasterPasswordValue.pure()) MasterPasswordValue oldPassword,
    @Default(MasterPasswordValue.pure()) MasterPasswordValue newPassword,
    @Default(ConfirmMasterPasswordValue.pure(''))
    ConfirmMasterPasswordValue confirmNewPassword,
    @Default(null) MasterPasswordValueError? oldPasswordError,
    @Default(null) MasterPasswordValueError? newPasswordError,
  }) = _ChangePasswordState;
}

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordState());

  void changeOldPassword(String value) {
    emit(state.copyWith(oldPassword: MasterPasswordValue.dirty(value)));
  }

  void changeNewPassword(String value) {
    emit(
      state.copyWith(
        newPassword: MasterPasswordValue.dirty(value),
        confirmNewPassword: state.confirmNewPassword.isPure
            ? ConfirmMasterPasswordValue.pure(value)
            : ConfirmMasterPasswordValue.dirty(value),
      ),
    );
  }

  void changeConfirmNewPassword(String value) {
    emit(
      state.copyWith(
        confirmNewPassword: ConfirmMasterPasswordValue.dirty(
          state.newPassword.value,
          value: value,
        ),
      ),
    );
  }

  Future<void> submit() async {
    emit(
      state.copyWith(
        oldPassword: MasterPasswordValue.dirty(state.oldPassword.value),
        newPassword: MasterPasswordValue.dirty(state.newPassword.value),
        confirmNewPassword: ConfirmMasterPasswordValue.dirty(
          state.newPassword.value,
          value: state.confirmNewPassword.value,
        ),
      ),
    );

    final isValid = Formz.validate([
      state.oldPassword,
      state.newPassword,
      state.confirmNewPassword,
    ]);

    if (!isValid) {
      return;
    }

    final email = await globalStore.getUsername();
    if (email == null) {
      emit(state.copyWith(status: .failure));
      return;
    }

    emit(state.copyWith(status: .submitting));

    // compute and derive all the keys.
    final oldMasterKey = await deriveMasterPassword(
      email,
      state.oldPassword.value,
    );
    final oldKek = await deriveKek(oldMasterKey);
    final oldAuthKey = await deriveAuthKey(oldMasterKey);
    final newMasterKey = await deriveMasterPassword(
      email,
      state.newPassword.value,
    );
    final newKek = await deriveKek(newMasterKey);
    final newAuthKey = await deriveAuthKey(newMasterKey);

    try {
      // start will a full sync to make sure the server and the local database
      // are up-t0-date
      await syncLocalAndRemote();
      var items = await globalDB.selectLocalStorage(withDeleted: true);
      var updated = <LocalStorageData>[];
      for (var item in items) {
        try {
          // if deleted, just update the updatedAtMs
          if (item.deleted) {
            updated.add(item.copyWith(updatedAtMs: generateVersion()));
          } else {
            logger.i('update ${item.id}');
            // re-encrypt the dek with the new masterKey
            updated.add(
              item.copyWith(
                updatedAtMs: generateVersion(),
                encryptedDek: await updateDekEncryption(
                  oldKek,
                  newKek,
                  item.encryptedDek,
                ),
              ),
            );
          }
        } catch (e) {
          logger.e(e);
        }
      }
      await API().updatePassword(
        UpdatePasswordInput(
          oldPassword: Uint8List.fromList(await oldAuthKey.extractBytes()),
          newPassword: Uint8List.fromList(await newAuthKey.extractBytes()),
          storageItems: updated
              .map(
                (e) => ApiStorage(
                  id: e.id,
                  updatedAtMs: e.updatedAtMs,
                  deleted: e.deleted,
                  encryptedDek: e.encryptedDek,
                  encryptedPayload: e.encryptedPayload,
                ),
              )
              .toList(),
        ),
      );
    } on ApiErrorBadRequestWithFields catch (e) {
      for (var error in e.errors) {
        if (error.field == 'old_password') {
          switch (error) {
            case FieldErrorCredentialsInvalid():
              emit(
                state.copyWith(
                  oldPasswordError: MasterPasswordValueInvalidError(),
                ),
              );
            case FieldErrorValueRequired():
              emit(
                state.copyWith(
                  oldPasswordError: MasterPasswordValueRequiredError(),
                ),
              );
            default:
          }
          if (error.field == 'new_password') {
            switch (error) {
              case FieldErrorValueRequired():
                emit(
                  state.copyWith(
                    newPasswordError: MasterPasswordValueRequiredError(),
                  ),
                );
              default:
            }
          }
        }
      }
      emit(state.copyWith(status: .ready));
      return;
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: .failure));
      emit(state.copyWith(status: .ready));
      return;
    } finally {
      // clean up keys in memory
      oldMasterKey.destroy();
      oldKek.destroy();
      oldAuthKey.destroy();
      newMasterKey.destroy();
      newKek.destroy();
      newAuthKey.destroy();
    }

    emit(state.copyWith(status: .success));
    emit(state.copyWith(status: .ready));
  }
}
