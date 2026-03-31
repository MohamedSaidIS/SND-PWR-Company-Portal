 import 'dart:async';
import 'package:company_portal/core/data/remote_data/dio_share_point/share_dio_config.dart';
import 'package:dio/dio.dart';

class SharePointDioClient {
  final dio = SharePointDioConfig.createDio();

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams, Options? options}) async {
    try{
      final response = await dio.get(endpoint, queryParameters: queryParams, options: options);
      return response.data;
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
          throw Exception('Failed to load data $e');
      }
    } catch (e) {
      throw Exception("Failed To load data $e");
    }
  }

  Future<Response> post(
    String endpoint, {
    Object? data,
    Options? options,
  }) async {
    try{
      final response = await dio.post(
        endpoint,
        data: data,
        options: options,
      );
      return response.data;
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
          throw Exception('Failed to load data $e');
      }
    } catch (e) {
      throw Exception("Failed To load data $e");
    }
  }
}
