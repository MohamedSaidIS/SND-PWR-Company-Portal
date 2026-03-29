import 'dart:convert';

import 'package:dio/dio.dart';

import '../data/remote_data/dio_graph/graph_dio_config.dart';

abstract class BaseApiService{
  Future<dynamic> get(String endPoint, {Map<String, dynamic>? params});
}

class GraphApiService extends BaseApiService {

  @override
  Future<dynamic> get(String endPoint, {Map<String, dynamic>? params}) async {
    final dio = GraphDioConfig.createDio();

    try{
      final response = await dio.get(endPoint, queryParameters: params
      );
      return response.data as Map<String, dynamic>;
    }on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception('Connection timeout - Please check your internet');
        case DioExceptionType.sendTimeout:
          throw Exception('Send timeout - Please try again');
        case DioExceptionType.receiveTimeout:
          throw Exception('Receive timeout - Server took too long to respond');
        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode;
          final message = e.response?.data?['message'] ?? 'Failed to load news';
          throw Exception('Server error ($statusCode): $message');
        case DioExceptionType.cancel:
          throw Exception('Request was cancelled');
        case DioExceptionType.connectionError:
          throw Exception('No internet connection');
        default:
          throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception("Failed To load Data");
    }

  }
}
