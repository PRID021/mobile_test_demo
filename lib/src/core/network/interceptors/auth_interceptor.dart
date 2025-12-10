import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:mobile_test_demo/src/data/datasources/auth_remote_data_source.dart';
import 'package:mobile_test_demo/src/data/models/user_credential_model.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final Future<String?> Function() getAccessToken;
  final Future<String?> Function() getRefreshToken;
  final Future<void> Function(UserCredentialModel token) saveToken;
  final AuthRemoteDataSource authRemote;
  final Logger logger;

  bool _isRefreshing = false;
  final List<Future<Response> Function()> _retryQueue = [];

  AuthInterceptor({
    required this.dio,
    required this.getAccessToken,
    required this.getRefreshToken,
    required this.saveToken,
    required this.authRemote,
    required this.logger,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    logger.d('🔐 Attaching token: ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.reject(err);
    }

    logger.w('⛔ Token expired — refreshing...');

    final refresh = await getRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      logger.w('❗ No refresh token');
      return handler.reject(err);
    }

    if (_isRefreshing) {
      logger.w('🔄 Already refreshing — queueing request');

      _retryQueue.add(() {
        return _retryRequest(err.requestOptions);
      });

      return;
    }

    _isRefreshing = true;

    try {
      final newToken = await authRemote.refreshToken(refresh);
      await saveToken(newToken);

      logger.i('🔄 Token refreshed');

      _isRefreshing = false;

      for (final retry in _retryQueue) {
        await retry();
      }
      _retryQueue.clear();

      final retryResponse = await _retryRequest(
        err.requestOptions,
        tokenOverride: newToken.accessToken,
      );

      return handler.resolve(retryResponse);
    } catch (e) {
      logger.e('❌ Refresh failed: $e');
      _isRefreshing = false;
      return handler.reject(err);
    }
  }

  Future<Response> _retryRequest(
    RequestOptions requestOptions, {
    String? tokenOverride,
  }) async {
    // Clone requestOptions để không mutate bản cũ
    final newOptions = Options(
      method: requestOptions.method,
      headers: Map<String, dynamic>.from(requestOptions.headers),
      contentType: requestOptions.contentType,
      responseType: requestOptions.responseType,
    );

    // Override token nếu có
    if (tokenOverride != null) {
      newOptions.headers?['Authorization'] = 'Bearer $tokenOverride';
    }

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: newOptions,
    );
  }
}
