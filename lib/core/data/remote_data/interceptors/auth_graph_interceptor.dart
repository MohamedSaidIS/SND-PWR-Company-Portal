import 'package:company_portal/core/data/remote_data/token_service.dart';
import 'package:dio/dio.dart';

import '../../../../utils/app_notifier.dart';
import '../../../service/secure_storage_service.dart';

class AuthGraphInterceptor extends Interceptor{

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    return handler.next(response);

  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    String? token = await SecureStorageService().getData("GraphAccessToken");

    final expired = await TokenService.isGraphTokenExpired();
    print("GraphToken is expired $expired");
    if (expired) {
      token = await TokenService.refreshGraphToken();
    }
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      print("GraphToken is expired ${err.response?.statusCode}");
      AppNotifier.sessionExpiredDialog();
    }
    handler.next(err);
  }

}