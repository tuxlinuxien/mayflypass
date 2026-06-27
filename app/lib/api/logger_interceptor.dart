import 'package:dio/dio.dart';
import 'package:mayflypass/core/core.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    apiLogger.d('>>> ${options.method} ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    apiLogger.d('${response.statusCode} ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }
}
