import 'package:company_portal/core/data/remote_data/interceptors/auth_share_point_interceptor.dart';
import 'package:company_portal/core/data/remote_data/interceptors/logging_interceptor.dart';
import 'package:dio/dio.dart';

import '../../../config/env_config.dart';

class SharePointDioConfig {
  static Dio createDio(){
    final dio = Dio(BaseOptions(
      baseUrl: EnvConfig.spBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.addAll([AuthSharePointInterceptor(), LoggingInterceptor()]);
    return dio;
  }
}