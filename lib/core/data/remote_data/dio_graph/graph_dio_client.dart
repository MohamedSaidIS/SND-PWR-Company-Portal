import 'package:company_portal/core/data/remote_data/dio_graph/graph_dio_config.dart';
import 'package:dio/dio.dart';

import '../dio_exception_handler.dart';



class GraphDioClient {
  final dio = GraphDioConfig.createDio();

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams, Options? options}) async {

    try{
      final response = await dio.get(endpoint, queryParameters: queryParams, options: options);
      return response;
    }on DioException catch (e) {
      throw DioExceptionHandler.handleException(e);
    } catch (e) {
      throw Exception("Failed To load data $e");
    }
  }

  Future<Response> post(String endPoint,
  {Map<String, dynamic>? data}) async {
    try{
      final response = await dio.post(endPoint, data: data);
      return response;
    }on DioException catch (e) {
      throw DioExceptionHandler.handleException(e);
    } catch (e) {
      throw Exception("Failed To load data $e");
    }
  }

  Future<Response> put(String endPoint,
      {Object? data, required Options options}) async {
    try{
      final response = await dio.put(endPoint, data: data, options: options);
      return response;
    }on DioException catch (e) {
      throw DioExceptionHandler.handleException(e);
    } catch (e) {
      throw Exception("Failed To load data $e");
    }
  }
}
