import 'package:company_portal/core/data/remote_data/dio_my_share_point/my_share_dio_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MySharePointDioClient {
  final dio = MySharePointDioConfig.createDio();

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    return await dio.get(endpoint, queryParameters: queryParams);
  }

  Future<Response> post(String endpoint, {
    Map<String, dynamic>? data,
    BuildContext? context,
  }) async {
    return await dio.post(
      endpoint,
      data: data,
      options: Options(extra: {"context": context}),
    );
  }
}
