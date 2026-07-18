import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/api/api.dart';
import 'package:mayflypass/core/core.dart';
import 'api_auth_test.dart';

void main() {
  initStore(MemoryStore());
  group('api account', () {
    test('account info', () async {
      await setupAccount();
      final response = await API().accountInfo();
      expect(response.username.isNotEmpty, true);
      expect(response.id.isNotEmpty, true);
    });

    test('account update password', () async {
      await setupAccount();
      final account = await API().accountInfo();
      final oldPassword = await buildPassword(account.username);
      final newPassword = await buildPassword(
        account.username,
        password: 'aaaaaaaa',
      );
      try {
        await API().updatePassword(
          UpdatePasswordInput(
            oldPassword: oldPassword,
            newPassword: newPassword,
            storageItems: [],
          ),
        );
      } catch (e) {
        logger.e(e);
        expect(false, true, reason: 'shouldn\'t be here');
      }
    });
  });
}
