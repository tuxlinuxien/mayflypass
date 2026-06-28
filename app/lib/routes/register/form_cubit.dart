import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mayflypass/api/api.dart';
import 'package:mayflypass/api/errors.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/helpers/errors.dart';
import 'package:mayflypass/secure/secure.dart';
import 'form_values.dart';

part 'form_cubit.freezed.dart';

enum FormStatus { initial, submitting, success, failure }

@freezed
abstract class RegisterFormState with _$RegisterFormState {
  const factory RegisterFormState({
    required RegisterForm form,
    @Default(FormStatus.initial) FormStatus status,
    ValueError? apiError,
    FieldError? apiEmailError,
  }) = _RegisterFormState;
}

class RegisterFormCubit extends Cubit<RegisterFormState> {
  RegisterFormCubit() : super(RegisterFormState(form: RegisterForm()));

  void emailChanged(String value) {
    emit(
      state.copyWith(
        form: state.form.copyWith(email: Email.dirty(value)),
        apiEmailError: null,
      ),
    );
  }

  void masterPasswordChanged(String value) {
    emit(
      state.copyWith(
        form: state.form.copyWith(
          masterPassword: MasterPassword.dirty(value),
          confirmMasterPassword: ConfirmMasterPassword.dirty(
            value,
            value: state.form.confirmMasterPassword.value,
          ),
        ),
      ),
    );
  }

  void confirmMasterPasswordChanged(String value) {
    emit(
      state.copyWith(
        form: state.form.copyWith(
          confirmMasterPassword: ConfirmMasterPassword.dirty(
            state.form.masterPassword.value,
            value: value,
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    if (!state.form.isValid) return;
    emit(state.copyWith(status: FormStatus.submitting, apiError: null));

    // create auth key
    final masterKey = await deriveMasterPassword(
      state.form.email.value,
      state.form.masterPassword.value,
    );
    final authKey = await deriveAuthKey(masterKey);

    try {
      // get the challenge
      final challenge = await API().challenge();
      final nonce = await challenge.solve();
      // register the account
      await API().register(
        RegisterInput(
          email: state.form.email.value,
          password: Uint8List.fromList(await authKey.extractBytes()),
          challengeKey: challenge.key,
          challengeNonce: nonce,
        ),
      );
    } on DioException catch (e) {
      final apiError = e.error;
      if (apiError is ApiErrorBadRequestWithFields) {
        for (final error in apiError.errors) {
          if (error.field == 'email') {
            emit(state.copyWith(apiEmailError: error));
          }
        }
      }
      emit(state.copyWith(status: FormStatus.failure));
      return;
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: FormStatus.failure));
      return;
    }

    emit(state.copyWith(status: FormStatus.success));
  }
}
