import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/api/api.dart';

void main() {
  group('auth api', () {
    test('login valid credentials', () async {
      final testEmail = '${DateTime.now().millisecondsSinceEpoch}@mail.com';
      final testPassword = '11111111';
      final cap = await API().generateCaptcha();
      await API().register(
        email: testEmail,
        password: testPassword,
        passwordRepeat: testPassword,
        cId: cap.id,
        cCode: '000000',
      );
      final resp = await API().login(testEmail, testPassword);
      expect(resp.accessToken.isNotEmpty, true);
      expect(resp.refreshToken.isNotEmpty, true);
    });

    test('get captcha', () async {
      final resp = await API().generateCaptcha();
      expect(resp.id.isNotEmpty, true);
      expect(resp.image.isNotEmpty, true);
    });

    test('register', () async {
      final testEmail = '${DateTime.now().microsecond}@mail.com';
      final cap = await API().generateCaptcha();
      await API().register(
        email: testEmail,
        password: '11111111',
        passwordRepeat: '11111111',
        cId: cap.id,
        cCode: '000000',
      );
    });

    test('refresh token', () async {
      final testEmail = '${DateTime.now().millisecondsSinceEpoch}@mail.com';
      final testPassword = '11111111';
      final cap = await API().generateCaptcha();
      await API().register(
        email: testEmail,
        password: testPassword,
        passwordRepeat: testPassword,
        cId: cap.id,
        cCode: '000000',
      );

      final tokens = await API().login(testEmail, testPassword);
      final resp = await API().refresh(tokens.refreshToken);
      expect(resp.accessToken.isNotEmpty, true);
      expect(resp.refreshToken.isNotEmpty, true);
    });

    test('account info', () async {
      final testEmail = '${DateTime.now().millisecondsSinceEpoch}@mail.com';
      final testPassword = '11111111';
      final cap = await API().generateCaptcha();
      await API().register(
        email: testEmail,
        password: testPassword,
        passwordRepeat: testPassword,
        cId: cap.id,
        cCode: '000000',
      );
      await API().login(testEmail, testPassword);
      final resp = await API().getAccountInfo();
      expect(resp.email, testEmail);
      expect(resp.id.isNotEmpty, true);
    });
  });
}
