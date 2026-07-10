import 'dart:typed_data';

import 'package:formz/formz.dart';
import 'package:mayflypass/api/api.dart';
import 'package:mayflypass/api/errors.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/forms/email.dart';
import 'package:mayflypass/forms/master_password.dart';
import 'package:mayflypass/secure/secure.dart';

part 'form_cubit.freezed.dart';

enum FormStatus { initial, submitting, success, failure }

@freezed
abstract class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    @Default(EmailValue.pure()) EmailValue email,
    @Default(MasterPasswordValue.pure()) MasterPasswordValue masterPassword,
    @Default(FormStatus.initial) FormStatus status,
    EmailValueError? emailError,
    ApiError? apiError,
  }) = _LoginFormState;
}

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(LoginFormState());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: EmailValue.dirty(value),
        apiError: null,
        emailError: null,
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
    final isValid = Formz.validate([state.email, state.masterPassword]);
    if (!isValid) return;

    // reset errors.
    emit(state.copyWith(status: FormStatus.submitting, apiError: null));

    // create auth key
    final masterKey = await deriveMasterPassword(
      state.email.value,
      state.masterPassword.value,
    );
    final authKey = await deriveAuthKey(masterKey);
    final sessionKey = await deriveSessionKey(masterKey);

    try {
      final email = state.email.value.trim().toLowerCase();
      // generate the auth key since we will need it for unlocking
      final authKeyBytes = await authKey.extractBytes();
      // now do an api query
      await API().login(
        LoginInput(email: email, password: Uint8List.fromList(authKeyBytes)),
      );
      // if the response is successfull, store the email and the unlock key.
      // the email will be used to rebuild the masterKey.
      await globalStore.setEmail(email);
      await globalStore.setSession(sessionKey);
      // keep the kek in memory
      final kek = await deriveKek(masterKey);
      setGlobalKek(kek);
      // keep it in the encrypted storage
      await globalStore.setKek(kek);
    } on ApiErrorBadRequestWithFields catch (e) {
      for (var error in e.errors) {
        if (error.field == 'email') {
          switch (error) {
            case FieldErrorCredentialsInvalid():
              emit(state.copyWith(emailError: EmailValueCredentialsError()));
            case FieldErrorEmailInvalid():
              emit(state.copyWith(emailError: EmailValueInvalidError()));
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
