import 'package:dio/dio.dart';
import 'errors.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(
      err.copyWith(
        error: ApiError.build(
          err.response?.statusCode ?? 0,
          err.response?.data,
        ),
      ),
    );
  }
}
