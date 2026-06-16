import 'package:dio/dio.dart';
import 'package:mayflypass/api/errors.dart';
import 'package:mayflypass/core/core.dart';

import 'error_interceptor.dart';
import 'logger_interceptor.dart';
import 'models.dart';
export 'models.dart';

abstract class _API {
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
}

class API extends _API {
  static final _dio = Dio(
    BaseOptions(
      baseUrl: API_URL,
      connectTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  )..interceptors.addAll([LoggerInterceptor(), ErrorInterceptor()]);
  static String? accessToken;
  static String? refreshToken;

  API();

  Future<Response<dynamic>> _request(
    String method,
    String path, {
    Object? data,
    Dio? customclient,
  }) async {
    final option = Options(method: method);
    final client = customclient ?? _dio;
    final response = await client.request(path, data: data, options: option);
    return response;
  }

  Future<Response<dynamic>> post(String path, {Object? data}) async {
    return _request('POST', path, data: data);
  }

  Future<Response<dynamic>> get(String path) async {
    return _request('GET', path);
  }

  Future<Response<dynamic>> _requestProtected(
    String method,
    String path, {
    Object? data,
  }) async {
    if (accessToken == null) {
      await refresh(refreshToken);
    }

    Future<Response<dynamic>> localRequest() async {
      final client = _dio.clone();
      client.options.headers.addEntries(
        {'Authorization': 'Bearer $accessToken'}.entries,
      );
      return _request(method, path, data: data, customclient: client);
    }

    try {
      return await localRequest();
    } on ApiErrorUnauthorized {
      await refresh(refreshToken);
    }
    return await localRequest();
  }

  Future<Response<dynamic>> postProtected(String path, {Object? data}) async {
    return _requestProtected('POST', path, data: data);
  }

  Future<Response<dynamic>> getProtected(String path) async {
    return _requestProtected('GET', path);
  }

  @override
  Future<LoginResponse> login(String email, String password) async {
    final payload = {'email': email, 'password': password};
    final response = await post('/api/login', data: payload);
    final output = LoginResponse.fromJson(response.data);
    // set the access token
    accessToken = output.accessToken;
    refreshToken = output.refreshToken;
    return output;
  }

  @override
  Future<CaptchaResult> generateCaptcha() async {
    final response = await get('/api/register');
    return CaptchaResult.fromJson(response.data);
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String passwordRepeat,
    required String cId,
    required String cCode,
  }) async {
    final payload = {
      'email': email,
      'password': password,
      'password_repeat': passwordRepeat,
      'c_id': cId,
      'c_code': cCode,
    };
    await post('/api/register', data: payload);
  }

  @override
  Future<RefreshResponse> refresh([String? refreshToken]) async {
    final payload = {'refresh_token': refreshToken};
    final response = await post('/api/refresh', data: payload);
    final output = RefreshResponse.fromJson(response.data);
    // set the access token
    accessToken = output.accessToken;
    refreshToken = output.refreshToken;

    return output;
  }

  @override
  Future<void> logout([String? refreshToken]) async {
    try {
      final payload = {'refresh_token': refreshToken};
      await post('/api/logout', data: payload);
      accessToken = null;
      refreshToken = null;
    } catch (_) {}
  }

  @override
  Future<AccountInfo> getAccountInfo() async {
    final response = await getProtected('/api/account/info');
    return AccountInfo.fromJson(response.data);
  }
}
