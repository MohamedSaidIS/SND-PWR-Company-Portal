import 'package:aad_oauth/aad_oauth.dart';
import 'package:company_portal/service/sharedpref_service.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/utils/secure_storage_service.dart';
import 'package:dio/dio.dart';
import '../config/env_config.dart';

class DioClient {
  late final Dio dio;
  final AadOAuth oauth;
  final SecureStorageService secureStorage = SecureStorageService();

  DioClient({required this.oauth}) {
    dio = Dio(BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await secureStorage.getData("AccessToken");

          final expired = await isTokenExpired();
          print("Token Expired $expired");
          if (expired) {
            token = await _refreshToken();
            print("Token Expired And New Token is $token");
          }
          if (token != null) {
            print("Token Expired And not null Token is $token");
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> isTokenExpired(
      {Duration expiryDuration = const Duration(hours: 1)}) async {

    String? savedAtStr = await secureStorage.getData("TokenSavedAt");

    if (savedAtStr == null) return true; // Token hadn't been saved yet

    final savedAt = DateTime.tryParse(savedAtStr);
    if (savedAt == null) return true;

    final now = DateTime.now();
    final expiryTime = savedAt.add(expiryDuration);
    return now.isAfter(expiryTime);
  }

  Future<String?> _refreshToken() async {
    try {
      final newToken = await oauth.getAccessToken();
      if (newToken != null) {

        await secureStorage.saveData("AccessToken", newToken.toString());
        await secureStorage.saveData("TokenSavedAt", DateTime.now().toIso8601String());

        print("Token Expired And New Token is $newToken");

        return newToken.toString();
      }
    } catch (e) {
      AppNotifier.printFunction('Refresh token failed', '$e');
    }
    return null;
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    return await dio.get(endpoint, queryParameters: queryParams);
  }
}
