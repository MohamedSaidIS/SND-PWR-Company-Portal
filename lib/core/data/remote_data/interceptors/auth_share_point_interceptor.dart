import 'package:company_portal/core/data/remote_data/token_service.dart';
import 'package:dio/dio.dart';

import '../../../../utils/app_notifier.dart';
import '../../../service/secure_storage_service.dart';

class AuthSharePointInterceptor extends Interceptor{

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    String? token = await SecureStorageService().getData("SPAccessToken");

    final expired = await TokenService.isSpTokenExpired();
    if (expired) {
      token = await TokenService.refreshSpToken();
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