import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/api/api.dart';
import 'package:mayflypass/core/core.dart';
import 'package:mayflypass/secure/derive.dart';

String buildTestEmail() {
  return '${DateTime.now().microsecond}@mail.com';
}

Future<List<int>> buildPassword(String email) async {
  final masterKey = await deriveMasterPassword(email, '12345678');
  return await (await deriveAuthKey(masterKey)).extractBytes();
}

Future<LoginResponse> setupAccount() async {
  final challenge = await API().challenge();
  final email = buildTestEmail();
  final password = await buildPassword(email);
  await API().register(
    RegisterInput(
      email: email,
      password: password,
      challengeKey: challenge.key,
      challengeNonce: await challenge.solve(),
    ),
  );
  return await API().login(LoginInput(email: email, password: password));
}

void main() {
  test('get challenge and solve it', () async {
    final resp = await API().challenge();
    expect(resp.key.length, 32);
    expect(resp.salt.length, 16);
    final now = DateTime.now();
    expect(await resp.solve() >= 0, true);
    final solved = DateTime.now();
    logger.i('solved ${solved.difference(now)}');
  });

  test('register new account', () async {
    final challenge = await API().challenge();
    final email = buildTestEmail();
    final password = await buildPassword(email);
    await API().register(
      RegisterInput(
        email: email,
        password: password,
        challengeKey: challenge.key,
        challengeNonce: await challenge.solve(),
      ),
    );
  });

  test('register new account  and login', () async {
    final challenge = await API().challenge();
    final email = buildTestEmail();
    final password = await buildPassword(email);
    await API().register(
      RegisterInput(
        email: email,
        password: password,
        challengeKey: challenge.key,
        challengeNonce: await challenge.solve(),
      ),
    );
    final response = await API().login(
      LoginInput(email: email, password: password),
    );
    expect(response.accessToken.isNotEmpty, true);
    expect(response.refreshToken.isNotEmpty, true);
  });

  test('refresh token', () async {
    final creds = await setupAccount();
    final response = await API().refresh(refreshToken: creds.refreshToken);
    expect(creds.accessToken != response.accessToken, true);
    expect(creds.refreshToken != response.refreshToken, true);
  });

  test('logout', () async {
    await setupAccount();
    await API().logout();
    try {
      await API().accountInfo();
      expect(true, false);
    } catch (_) {}
  });

  test('account info', () async {
    await setupAccount();
    final response = await API().accountInfo();
    expect(response.email.isNotEmpty, true);
    expect(response.id.isNotEmpty, true);
  });
}
