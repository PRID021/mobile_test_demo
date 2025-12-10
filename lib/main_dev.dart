import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_test_demo/app.dart';
import 'package:mobile_test_demo/src/core/di/service_locator.dart';
import 'package:mobile_test_demo/src/core/network/auth_dio_client.dart';
import 'package:mobile_test_demo/src/data/datasources/auth_remote_data_source.dart';

Future<void> main() async {
  const env = 'DEV';
  const baseUrl = 'https://api-dev.example.com';

  sl = GetIt.instance;
  sl.allowReassignment = true;
  await initDependencies(baseUrl, sl);

  // If in dev, override with the mock
  sl.unregister<AuthRemoteDataSource>();

  final dio = sl<Dio>();
  final authDioClient = sl<AuthDioClient>();
  dio.options.baseUrl = baseUrl;
  authDioClient.dio.options.baseUrl = baseUrl;

  const mockEmail = 'hoangduc.uit.dev@gmail.com';
  const mockPassword = 'Password123@@';

  // Mock for login endpoint
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.path == '/login') {
          final data = options.data as Map<String, dynamic>?;

          // Check if request body exists
          if (data == null ||
              !data.containsKey('email') ||
              !data.containsKey('password')) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 400,
                  data: {'message': 'Missing email or password'},
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          }

          final email = data['email'] as String;
          final password = data['password'] as String;

          // Check credentials
          if (email == mockEmail && password == mockPassword) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'access_token': 'mock_access_token',
                  'refresh_token': 'mock_refresh_token',
                  'user_id': 'mock_user_id',
                },
              ),
            );
          } else {
            // Invalid credentials
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 401,
                  data: {'message': 'Invalid email or password'},
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          }
        }

        // Pass through other requests
        handler.next(options);
      },
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio),
  );

  /// Mock for contacts endpoint
  authDioClient.dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.path == '/contacts') {
          // Load JSON from asset
          final jsonString =
              await rootBundle.loadString('assets/mock_contacts.json');
          return handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: jsonString,
            ),
          );
        }
        handler.next(options);
      },
    ),
  );

  runApp(const MyApp(environment: env, baseUrl: baseUrl));
}
