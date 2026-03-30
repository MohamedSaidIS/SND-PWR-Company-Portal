import 'package:company_portal/core/data/remote_data/dio_graph/graph_dio_config.dart';
import 'package:dio/dio.dart';


class GraphDioClient {
  final dio = GraphDioConfig.createDio();

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams, Options? options}) async {
    return await dio.get(endpoint, queryParameters: queryParams, options: options);
  }

  Future<Response> post(String endPoint,
  {Map<String, dynamic>? data}) async {
    return await dio.post(endPoint, data: data);
  }

  Future<Response> put(String endPoint,
      {Object? data, required Options options}) async {
    return await dio.put(endPoint, data: data, options: options);
  }
}
