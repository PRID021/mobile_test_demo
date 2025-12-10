import 'package:dio/dio.dart';
import 'package:mobile_test_demo/src/core/error/exceptions.dart';
import 'package:mobile_test_demo/src/core/utils/json_isolate.dart';
import 'package:mobile_test_demo/src/data/models/user_credential_model.dart';

/// Abstract layer: chỉ định testcase contract, không có Dio
abstract class AuthRemoteDataSource {
  Future<UserCredentialModel> login(String email, String password);
  Future<UserCredentialModel> refreshToken(String refreshToken);
}

/// Implementation: xử lý Dio + JSON parsing + Exception
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<UserCredentialModel> login(String email, String password) async {
    try {
      final response = await client.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // ⚡ JSON parsing diễn ra trong isolate → không block UI
      return await parseCredentialInBackground(response.toString());
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<UserCredentialModel> refreshToken(String refreshToken) async {
    try {
      final response = await client.post(
        '/refresh',
        data: {
          'refresh_token': refreshToken,
        },
      );

      // ⚡ Offload JSON parse
      return await parseCredentialInBackground(response.toString());
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  // -------------------------------------------------------------
  //                      INTERNAL HELPERS
  // -------------------------------------------------------------

  AppException _mapDioError(DioException e) {
    final code = e.response?.statusCode;

    if (e.type == DioExceptionType.connectionError) {
      return NetworkException(message: 'Không thể kết nối server');
    }

    if (code == 401) {
      return UnauthorizedException();
    }

    if (code != null && code >= 500) {
      return ServerException(
        message: 'Lỗi server (${e.message})',
        statusCode: code,
      );
    }

    return ServerException(
      message: e.message ?? 'Lỗi không xác định',
      statusCode: code,
    );
  }
}