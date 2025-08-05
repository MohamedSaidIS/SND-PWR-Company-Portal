import 'package:aad_oauth/aad_oauth.dart';
import 'package:company_portal/service/sharedpref_service.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:dio/dio.dart';
import '../config/env_config.dart';

class DioClient {
  late final Dio dio;
  final AadOAuth oauth;

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
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final prefs = SharedPrefsHelper();
      String? token = await prefs.getUserData("AccessToken");

      final expired = await isTokenExpired();
      print("Token Expired $expired");
      if (expired) {
        print("Token Expired And New Token is $token");
        token = await _refreshToken();
      }

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    }, onError: (error, handler) {
      return handler.next(error);
    }));
  }

  Future<bool> isTokenExpired(
      {Duration expiryDuration = const Duration(hours: 1)}) async {
    final prefs = SharedPrefsHelper();
    String? savedAtStr = await prefs.getUserData("TokenSavedAt");

    if (savedAtStr == null) return true; // Token hadn't been saved yet

    final savedAt = DateTime.tryParse(savedAtStr);
    if (savedAt == null) return true;

    final now = DateTime.now();
    final expiryTime = savedAt.add(expiryDuration);
    return now.isAfter(expiryTime);
  }

  Future<String?> _refreshToken() async {
    try {
      final newToken = await oauth.refreshToken();
      if (newToken != null) {
        final prefs = SharedPrefsHelper();
        await prefs.saveUserData("AccessToken", newToken.toString());
        await prefs.saveUserData(
            "TokenSavedAt", DateTime.now().toIso8601String());
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
