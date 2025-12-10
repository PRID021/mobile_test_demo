import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

// ✔ Dùng logger.i, logger.e
// ✔ Log gọn, đẹp, không spam
// ✔ Không block UI thread

class LoggerInterceptor extends Interceptor {
  final Logger logger;

  LoggerInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i(
      '➡️ REQUEST\n'
      'URL: ${options.method} ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Data: ${options.data}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(
      '✔️ RESPONSE\n'
      'Status: ${response.statusCode}\n'
      'Data: ${response.data}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e(
      '❌ ERROR\n'
      'Status: ${err.response?.statusCode}\n'
      'Message: ${err.message}\n'
      'Data: ${err.response?.data}',
    );
    super.onError(err, handler);
  }
}
