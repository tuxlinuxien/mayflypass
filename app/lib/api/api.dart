import 'models.dart';
export 'models.dart';

abstract class API {
  Future<LoginResponse> login(String email, String password);
  Future<void> register({
    required String email,
    required String password,
    required String passwordRepeat,
    required String cId,
    required String cCode,
  });
  Future<CaptchaResult> generateCaptcha();
  Future<RefreshResponse> refresh([String? refreshToken]);
  Future<void> logout([String? refreshToken]);
  Future<AccountInfo> getAccountInfo();
  Future<Account> getAccount();
}
