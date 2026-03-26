 import 'dart:async';
import 'package:company_portal/core/data/remote_data/dio_share_point/share_dio_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SharePointDioClient {
  final dio = SharePointDioConfig.createDio();

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    return await dio.get(endpoint, queryParameters: queryParams);
  }

  Future<Response> post(
    String endpoint, {
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
