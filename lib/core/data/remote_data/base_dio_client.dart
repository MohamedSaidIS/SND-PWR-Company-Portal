import 'package:dio/dio.dart';

abstract class BaseDioClient {
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParams, Options? options});
  Future<Response> post(String endpoint, {Map<String, dynamic>? queryParams, Options? options});
  Future<Response> put(String endpoint, {Map<String, dynamic>? queryParams, Options? options});
}