import 'package:dio/dio.dart';
import 'package:mayflypass/core/logger.dart';
import 'errors.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      err = err.copyWith(
        error: ApiError.build(
          err.response?.statusCode ?? 0,
          err.response?.data,
        ),
      );
    } catch (_) {
      logger.e(err);
      err = err.copyWith(error: ApiErrorUnknown());
    }

    handler.reject(err);
  }
}
