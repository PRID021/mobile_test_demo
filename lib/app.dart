import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_test_demo/src/core/di/service_locator.dart';
import 'package:mobile_test_demo/src/domain/repositories/auth_repository.dart';
import 'package:mobile_test_demo/src/domain/repositories/contact_repository.dart';
import 'package:mobile_test_demo/src/presentation/bloc/app/app_bloc.dart';
import 'package:mobile_test_demo/src/presentation/routes/app_router.dart';
import 'package:mobile_test_demo/src/presentation/routes/route_paths.dart';
import 'package:mobile_test_demo/src/presentation/theme/app_theme.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  final String environment;
  final String baseUrl;

  const MyApp({
    super.key,
    required this.environment,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => sl<AuthRepository>(),
        ),
        Provider<ContactRepository>(
          create: (context) => sl<ContactRepository>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Mobile Test Demo ($environment)',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        builder: (context, child) {
          return BlocProvider(
            create: (context) =>AppBloc(tokenStorage: sl()),
            child: BlocListener<AppBloc, AppState>(
              listenWhen: (old, next) => true,
              listener: (context, state) {
                if (state is Unauthenticated) {
                  appNavigatorKey.currentContext?.go(RoutePaths.login);
                }

                if (state is Authenticated) {
                  final currentPath =
                      GoRouter.of(appNavigatorKey.currentContext!).state.path;
                  if (currentPath == RoutePaths.login ||
                      currentPath == RoutePaths.splash) {
                    appNavigatorKey.currentContext?.go(RoutePaths.home);
                  }
                }
              },
              child: child,
            ),
          );
        },
      ),
    );
  }
}
