import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mayflypass/api/api.dart';
import 'package:mayflypass/api/errors.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/secure/secure.dart';
import 'form_values.dart';

part 'form_cubit.freezed.dart';

enum FormStatus { initial, submitting, success, failure }

@freezed
abstract class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    @Default(Email.pure()) Email email,
    @Default(MasterPassword.pure()) MasterPassword masterPassword,
    @Default(FormStatus.initial) FormStatus status,
    EmailError? emailError,
    ApiError? apiError,
  }) = _LoginFormState;
}

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(LoginFormState());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: Email.dirty(value),
        apiError: null,
        emailError: null,
      ),
    );
  }

  void masterPasswordChanged(String value) {
    emit(
      state.copyWith(
        masterPassword: MasterPassword.dirty(value),
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

    try {
      final authKeyBytes = await authKey.extractBytes();
      final response = await API().login(
        LoginInput(
          email: state.email.value,
          password: Uint8List.fromList(authKeyBytes),
        ),
      );
      await StorageSetApiRefreshToken(response.refreshToken);
      await StorageSetAccount(state.email.value.trim().toLowerCase());
    } on ApiErrorBadRequestWithFields catch (e) {
      for (var error in e.errors) {
        if (error.field == 'email') {
          switch (error) {
            case FieldErrorCredentialsInvalid():
              emit(state.copyWith(emailError: EmailInvalidCredentialsError()));
            case FieldErrorEmailInvalid():
              emit(state.copyWith(emailError: EmailInvalidError()));
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
