import 'package:aad_oauth/aad_oauth.dart';
import 'package:company_portal/service/sharedpref_service.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/utils/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../config/env_config.dart';

class DioClient {
  late final Dio dio;
  final FlutterAppAuth appAuth;
  final SecureStorageService secureStorage = SecureStorageService();

  DioClient({required this.appAuth}) {
    dio = Dio(BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
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
      final refreshToken = await secureStorage.getData("RefreshToken");
      if (refreshToken == null) {
        AppNotifier.printFunction("RefreshToken missing", "User must login again");
        return null;
      }

      final TokenResponse result = await appAuth.token(
        TokenRequest(
          EnvConfig.msClientId,
          EnvConfig.msRedirectUri,
          discoveryUrl:
          "https://login.microsoftonline.com/${EnvConfig.msTenantId}/v2.0/.well-known/openid-configuration",
          refreshToken: refreshToken,
          scopes: ["openid", "profile", "User.read", "offline_access"],
        ),
      );

      if (result == null || result.accessToken == null) {
        AppNotifier.printFunction("Refresh failed", "Null token response");
        return null;
      }

      // Save tokens again
      await secureStorage.saveData("AccessToken", result.accessToken!);
      if (result.refreshToken != null) {
        await secureStorage.saveData("RefreshToken", result.refreshToken!);
      }
      await secureStorage.saveData("TokenSavedAt", DateTime.now().toIso8601String());

      return result.accessToken!;
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
