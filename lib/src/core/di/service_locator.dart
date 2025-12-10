import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mobile_test_demo/src/core/network/auth_dio_client.dart';
import 'package:mobile_test_demo/src/core/network/interceptors/auth_interceptor.dart';
import 'package:mobile_test_demo/src/core/storage/token_storage.dart';
import 'package:mobile_test_demo/src/data/datasources/auth_remote_data_source.dart';
import 'package:mobile_test_demo/src/data/datasources/contact_remote_data_source.dart';
import 'package:mobile_test_demo/src/data/repositories/auth_repository_impl.dart';
import 'package:mobile_test_demo/src/data/repositories/contact_repository_impl.dart';
import 'package:mobile_test_demo/src/domain/repositories/auth_repository.dart';
import 'package:mobile_test_demo/src/domain/repositories/contact_repository.dart';

late final GetIt sl;

Future<void> initDependencies(String baseUrl, GetIt sl) async {
  sl.registerLazySingleton<TokenStorage>(() => TokenStorageImpl());
  sl.registerLazySingleton<Logger>(() => Logger());

  /// Unauthenticated Dio Client
  // Used for endpoints that do not require authentication
  final unAuthenticatedDio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
    ),
  );
  unAuthenticatedDio.interceptors.addAll([
    LogInterceptor(requestBody: true, responseBody: true),
  ]);

  sl.registerSingleton<Dio>(unAuthenticatedDio);
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(unAuthenticatedDio),
  );

  /// Authenticated Dio Client
  /// Used for endpoints that require authentication
  final authDioClient = AuthDioClient();
  authDioClient.dio.interceptors.addAll([
    LogInterceptor(requestBody: true, responseBody: true),
    AuthInterceptor(
      dio: authDioClient.dio,
      getAccessToken: () => sl<TokenStorage>().getAccessToken(),
      getRefreshToken: () => sl<TokenStorage>().getRefreshToken(),
      saveToken: (token) async {
        await sl<TokenStorage>().saveAccessToken(token.accessToken);
        await sl<TokenStorage>().saveRefreshToken(token.refreshToken);
      },
      authRemote: sl(),
      logger: sl<Logger>(),
    )
  ]);
  sl.registerSingleton<AuthDioClient>(authDioClient);

  // Data Sources

  sl.registerLazySingleton<ContactRemoteDataSource>(
      () => ContactRemoteDataSourceImpl(sl<AuthDioClient>()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: sl<AuthRemoteDataSource>(),
      tokenStorage: sl<TokenStorage>(),
    ),
  );
  sl.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(remoteDataSource: sl()),
  );
}
