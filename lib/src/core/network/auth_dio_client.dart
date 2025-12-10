import 'package:dio/dio.dart';

class AuthDioClient {
  final Dio dio;
  AuthDioClient()
      : dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
          ),
        );
}
