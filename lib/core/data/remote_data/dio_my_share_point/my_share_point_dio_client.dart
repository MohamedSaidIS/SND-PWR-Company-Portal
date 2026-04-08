import 'package:company_portal/core/data/remote_data/dio_my_share_point/my_share_dio_config.dart';
import 'package:dio/dio.dart';

import '../dio_exception_handler.dart';

class MySharePointDioClient{
  final dio = MySharePointDioConfig.createDio();

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams, Options? options}) async {try{
    final response = await dio.get(endpoint, queryParameters: queryParams, options: options);
    return response;
  }on DioException catch (e) {
    throw DioExceptionHandler.handleException(e);
  } catch (e) {
    throw Exception("Failed To load data $e");
  }
  }

  Future<Response> post(String endpoint, {
    Object? data,
    Options? options,
  }) async {
    try{
      final response = await dio.post(endpoint, data: data, options: options);
      return response;
    }on DioException catch (e) {
      throw DioExceptionHandler.handleException(e);
    } catch (e) {
      throw Exception("Failed To load data $e");
    }
  }
}
