import 'package:company_portal/core/data/remote_data/token_service.dart';
import 'package:dio/dio.dart';

import '../../../../utils/app_notifier.dart';
import '../../../service/secure_storage_service.dart';

class AuthMySharePointInterceptor extends Interceptor{

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    String? token = await SecureStorageService().getData("MySPAccessToken");

    final expired = await TokenService.isMyShareTokenExpired();
    if (expired) {
      token = await TokenService.refreshMyShareToken();
    }
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      AppNotifier.sessionExpiredDialog();
    }
    handler.next(err);
  }

}