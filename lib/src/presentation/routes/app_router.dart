import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_test_demo/src/presentation/pages/comming_soon/feature_comming_soon.dart';
import 'package:mobile_test_demo/src/presentation/pages/home/home_page.dart';
import 'package:mobile_test_demo/src/presentation/pages/login/login_page.dart';
import 'package:mobile_test_demo/src/presentation/pages/splash/splash_page.dart';
import 'package:mobile_test_demo/src/presentation/routes/route_names.dart';
import 'package:mobile_test_demo/src/presentation/routes/route_paths.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: appNavigatorKey,
  initialLocation: RoutePaths.splash,
  routes: [
    GoRoute(
      name: RouteNames.splash,
      path: RoutePaths.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
        name: RouteNames.home,
        path: RoutePaths.home,
        builder: (context, state) => const HomePage(),
        // ignore: prefer_const_literals_to_create_immutables
        routes: [
          // GoRoute(
          //   path: 'contact/:id',
          //   name: 'contact',
          //   builder: (context, state) {
          //     final id = state.pathParameters['id']!;
          //     return ContactDetailPage(id: id);
          //   },
          // ),
        ]),
    GoRoute(
      name: RouteNames.login,
      path: RoutePaths.login,
      builder: (context, state) => const LoginPage(),
    ),
  ],
  // Khi route không tồn tại
  errorBuilder: (context, state) => const FeatureComingSoonPage(),
);
