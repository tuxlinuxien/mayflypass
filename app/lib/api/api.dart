import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mayflypass/api/errors.dart';
import 'package:mayflypass/core/core.dart';

import 'error_interceptor.dart';
import 'logger_interceptor.dart';
import 'models.dart';
export 'models.dart';

abstract class _API {
  // auth
  Future<LoginResponse> login(LoginInput input);
  Future<void> register(RegisterInput input);
  Future<ChallengeResult> challenge();
  Future<RefreshResponse> refresh({String? refreshToken});
  Future<void> logout();
  // account
  Future<AccountInfo> accountInfo();
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
    Future<Response<dynamic>> localRequest() async {
      final client = _dio.clone();
      client.options.headers.addEntries(
        {'Authorization': 'Bearer ${API.accessToken}'}.entries,
      );
      return _request(method, path, data: data, customclient: client);
    }

    try {
      // refresh the token now since we don't have any accessToken
      if (API.accessToken == null) {
        logger.w('refresh token');
        await refresh(refreshToken: API.refreshToken);
      }
      return await localRequest();
    } on ApiErrorUnauthorized {
      logger.w('refresh token');
      await refresh(refreshToken: API.refreshToken);
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
  Future<LoginResponse> login(LoginInput input) async {
    final response = await post('/api/login', data: input.toJson());
    final output = LoginResponse.fromJson(response.data);
    // set the access token
    API.accessToken = output.accessToken;
    API.refreshToken = output.refreshToken;
    return output;
  }

  @override
  Future<ChallengeResult> challenge() async {
    final response = await get('/api/register');
    return ChallengeResult.fromJson(response.data);
  }

  @override
  Future<void> register(RegisterInput input) async {
    await post('/api/register', data: input.toJson());
  }

  @override
  Future<RefreshResponse> refresh({String? refreshToken}) async {
    final payload = {'refresh_token': refreshToken};
    final response = await post('/api/refresh', data: jsonEncode(payload));
    final output = RefreshResponse.fromJson(response.data);
    // set the access token
    API.accessToken = output.accessToken;
    API.refreshToken = output.refreshToken;
    return output;
  }

  @override
  Future<void> logout() async {
    try {
      final payload = {'refresh_token': refreshToken};
      await post('/api/logout', data: jsonEncode(payload));
    } catch (e) {
      logger.e('logout error $e');
    } finally {
      API.accessToken = null;
      API.refreshToken = null;
    }
  }

  @override
  Future<AccountInfo> accountInfo() async {
    final response = await getProtected('/api/account/info');
    return AccountInfo.fromJson(response.data);
  }
}
