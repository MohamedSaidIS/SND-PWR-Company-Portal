import 'package:company_portal/core/data/remote_data/interceptors/auth_graph_interceptor.dart';
import 'package:company_portal/core/data/remote_data/interceptors/logging_interceptor.dart';
import 'package:dio/dio.dart';

import '../../../config/env_config.dart';

class GraphDioConfig {
  static Dio createDio(){
    final dio = Dio(BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.addAll([AuthGraphInterceptor(), LoggingInterceptor()]);
    return dio;
  }
}