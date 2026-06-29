import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
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
    @Default(Email.pure()) Email email,
    @Default(MasterPassword.pure()) MasterPassword masterPassword,
    @Default(ConfirmMasterPassword.pure(''))
    ConfirmMasterPassword confirmMasterPassword,
    @Default(FormStatus.initial) FormStatus status,
    ValueError? apiError,
    FieldError? apiEmailError,
  }) = _RegisterFormState;
}

class RegisterFormCubit extends Cubit<RegisterFormState> {
  RegisterFormCubit() : super(RegisterFormState());

  void emailChanged(String value) {
    emit(state.copyWith(email: Email.dirty(value), apiEmailError: null));
  }

  void masterPasswordChanged(String value) {
    emit(
      state.copyWith(
        masterPassword: MasterPassword.dirty(value),
        confirmMasterPassword: ConfirmMasterPassword.dirty(
          value,
          value: state.confirmMasterPassword.value,
        ),
      ),
    );
  }

  void confirmMasterPasswordChanged(String value) {
    emit(
      state.copyWith(
        confirmMasterPassword: ConfirmMasterPassword.dirty(
          state.masterPassword.value,
          value: value,
        ),
      ),
    );
  }

  Future<void> submit() async {
    final isValid = Formz.validate([
      state.email,
      state.masterPassword,
      state.confirmMasterPassword,
    ]);
    if (!isValid) return;

    emit(state.copyWith(status: FormStatus.submitting, apiError: null));

    logger.i('derive auth password');
    // create auth key
    final masterKey = await deriveMasterPassword(
      state.email.value,
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
          email: state.email.value,
          password: Uint8List.fromList(await authKey.extractBytes()),
          challengeKey: challenge.key,
          challengeNonce: nonce,
        ),
      );
    } on ApiErrorBadRequestWithFields catch (e) {
      for (final error in e.errors) {
        if (error.field == 'email') {
          emit(state.copyWith(apiEmailError: error));
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
