import 'dart:typed_data';

import 'package:formz/formz.dart';
import 'package:mayflypass/api/api.dart';
import 'package:mayflypass/api/errors.dart';
import 'package:mayflypass/core/auth.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/database/database.dart';
import 'package:mayflypass/forms/username.dart';
import 'package:mayflypass/forms/master_password.dart';
import 'package:mayflypass/helpers/sync.dart';
import 'package:mayflypass/secure/secure.dart';

part 'form_cubit.freezed.dart';

enum FormStatus { initial, submitting, success, failure }

@freezed
abstract class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    @Default(UsernameValue.pure()) UsernameValue username,
    @Default(MasterPasswordValue.pure()) MasterPasswordValue masterPassword,
    @Default(FormStatus.initial) FormStatus status,
    UsernameValueError? usernameError,
    ApiError? apiError,
  }) = _LoginFormState;
}

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(LoginFormState());

  void usernameChanged(String value) {
    emit(
      state.copyWith(
        username: UsernameValue.dirty(value),
        apiError: null,
        usernameError: null,
      ),
    );
  }

  void masterPasswordChanged(String value) {
    emit(
      state.copyWith(
        masterPassword: MasterPasswordValue.dirty(value),
        apiError: null,
      ),
    );
  }

  Future<void> submit() async {
    final isValid = Formz.validate([state.username, state.masterPassword]);
    if (!isValid) return;

    // reset errors.
    emit(state.copyWith(status: FormStatus.submitting, apiError: null));

    // create auth key
    final masterKey = await deriveMasterPassword(
      state.username.value,
      state.masterPassword.value,
    );
    final authKey = await deriveAuthKey(masterKey);
    final sessionKey = await deriveSessionKey(masterKey);

    try {
      // remove every stored configuration
      await globalStore.flushAll();

      final username = state.username.value.trim().toLowerCase();
      // generate the auth key since we will need it for unlocking
      final authKeyBytes = await authKey.extractBytes();
      // now do an api query
      await API().login(
        LoginInput(
          username: username,
          password: Uint8List.fromList(authKeyBytes),
        ),
      );
      // if the response is successful, store the email and the unlock key.
      // the email will be used to rebuild the masterKey.
      await globalStore.setUsername(username);
      await globalStore.setSession(sessionKey);
      // keep the kek in memory
      final kek = await deriveKek(masterKey);
      setGlobalKek(kek);
      // clean up previous entries
      await globalDB.deleteAllLocalStorage();
      await syncLocalAndRemote();
      await globalAuth.unlocked();
    } on ApiErrorBadRequestWithFields catch (e) {
      for (var error in e.errors) {
        if (error.field == 'username') {
          switch (error) {
            case FieldErrorCredentialsInvalid():
              emit(
                state.copyWith(usernameError: UsernameValueCredentialsError()),
              );
            case FieldErrorUsernameInvalid():
              emit(state.copyWith(usernameError: UsernameValueInvalidError()));
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
      sessionKey.destroy();
    }

    emit(state.copyWith(status: FormStatus.success));
  }
}
