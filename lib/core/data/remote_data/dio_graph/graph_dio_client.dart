import 'package:company_portal/core/data/remote_data/dio_graph/graph_dio_config.dart';
import 'package:dio/dio.dart';


class GraphDioClient {
  final dio = GraphDioConfig.createDio();

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    return await dio.get(endpoint, queryParameters: queryParams);
  }
}
