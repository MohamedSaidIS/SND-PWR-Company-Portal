import 'package:company_portal/core/data/remote_data/dio_my_share_point/my_share_dio_config.dart';
import 'package:dio/dio.dart';

class MySharePointDioClient {
  final dio = MySharePointDioConfig.createDio();

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams, Options? options}) async {
    return await dio.get(endpoint, queryParameters: queryParams, options: options);
  }

  Future<Response> post(String endpoint, {
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
