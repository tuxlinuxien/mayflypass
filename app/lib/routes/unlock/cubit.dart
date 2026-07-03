import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/router.dart';
import 'package:mayflypass/secure/secure.dart';
import 'form.dart';

part 'cubit.freezed.dart';

enum FormStatus { initial, submitting, success, failure }

@freezed
abstract class UnlockFormState with _$UnlockFormState {
  const factory UnlockFormState({
    @Default(MasterPassword.pure()) MasterPassword masterPassword,
    @Default(FormStatus.initial) FormStatus status,
  }) = _UnlockFormState;
}

class FormCubit extends Cubit<UnlockFormState> {
  FormCubit() : super(UnlockFormState());

  void masterPasswordChanged(String value) {
    emit(
      state.copyWith(
        status: .initial,
        masterPassword: MasterPassword.dirty(value),
      ),
    );
  }

  void unlock() async {
    final isValid = Formz.validate([state.masterPassword]);
    if (!isValid) return;

    emit(state.copyWith(status: .submitting));

    final email = await storage.getEmail();
    final unlockKeyBytes = await storage.getUnlockKey();
    if (email == null || unlockKeyBytes == null) {
      zeroing(unlockKeyBytes ?? []);
      router.go('/login');
      return;
    }

    final password = state.masterPassword.value;
    final masterKey = await deriveMasterPassword(email, password);
    final unlockKey = await deriveUnlockKey(masterKey);
    final isMatch = await compareUnlockKeys(unlockKeyBytes, unlockKey);
    // clean up memory now
    zeroing(unlockKeyBytes);
    unlockKey.destroy();
    // now we compare that the password is correct
    if (isMatch == false) {
      logger.e('invalid password');
      emit(state.copyWith(status: .failure));
      return;
    }
    emit(state.copyWith(status: .success));
  }
}

Future<bool> compareUnlockKeys(
  List<int> unlockKeyBytes,
  SecretKey unlockKey,
) async {
  final bytes = await unlockKey.extractBytes();
  if (bytes.length != unlockKeyBytes.length) return false;

  var r = 0;
  for (int i = 0; i < bytes.length; i++) {
    r |= bytes[i] ^ unlockKeyBytes[i];
  }
  return r == 0;
}
