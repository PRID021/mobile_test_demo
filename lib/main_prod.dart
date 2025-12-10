import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_test_demo/app.dart';
import 'package:mobile_test_demo/src/core/di/service_locator.dart';

Future<void> main() async {
  const env = 'PROD';
  const baseUrl = 'https://api.example.com';
  sl = GetIt.instance;
  await initDependencies(baseUrl, sl);
  runApp(const MyApp(environment: env, baseUrl: baseUrl));
}
