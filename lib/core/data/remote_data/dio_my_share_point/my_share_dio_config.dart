import 'package:company_portal/core/data/remote_data/interceptors/logging_interceptor.dart';
import 'package:dio/dio.dart';
import '../../../config/env_config.dart';
import '../interceptors/auth_my_share_point_interceptor.dart';

class MySharePointDioConfig {
  static Dio createDio(){
    final dio = Dio(BaseOptions(
      baseUrl: EnvConfig.mySpBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.addAll([AuthMySharePointInterceptor(), LoggingInterceptor()]);
    return dio;
  }
}