 import 'dart:async';
import 'package:company_portal/core/data/remote_data/dio_share_point/share_dio_config.dart';
import 'package:dio/dio.dart';

class SharePointDioClient {
  final dio = SharePointDioConfig.createDio();

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams, Options? options}) async {
    return await dio.get(endpoint, queryParameters: queryParams, options: options);
  }

  Future<Response> post(
    String endpoint, {
    Object? data,
    Options? options,
  }) async {
    return await dio.post(
      endpoint,
      data: data,
      options: options,
    );
  }
}
