import 'dart:ui';

import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/service/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../config/env_config.dart';

class SharePointDioClient {
  late final Dio dio;
  final FlutterAppAuth appAuth;
  final SecureStorageService secureStorage = SecureStorageService();

  final VoidCallback onUnauthorized;

  SharePointDioClient({required this.appAuth, required this.onUnauthorized}) {
    dio = Dio(BaseOptions(
      baseUrl: EnvConfig.spBaseUrl,
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
          String? token = await secureStorage.getData("MySharePointAccessToken");

          final expired = await isTokenExpired();
          AppNotifier.logWithScreen("MySharePoint DioClient","MySharePoint AccessToken Expired $expired");
          if (expired) {
            token = await _refreshToken();
            AppNotifier.logWithScreen("MySharePoint DioClient","MySharePoint AccessToken Expired And New Token is $token");
          }
          if (token != null) {
            AppNotifier.logWithScreen("MySharePoint DioClient","MySharePoint AccessToken Expired And not null Token is $token");
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Logout or redirect to login
            AppNotifier.logWithScreen("MySharePoint DioClient","MySharePoint AccessToken Expired And Error 401");
            onUnauthorized();
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> isTokenExpired(
      {Duration expiryDuration = const Duration(hours: 1)}) async {
    String? savedAtStr = await secureStorage.getData("MySharedTokenSavedAt");

    if (savedAtStr == "") return true; // Token hadn't been saved yet

    final savedAt = DateTime.tryParse(savedAtStr);
    if (savedAt == null) return true;

    final now = DateTime.now();
    final expiryTime = savedAt.add(expiryDuration);
    return now.isAfter(expiryTime);
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await secureStorage.getData("RefreshToken");
      if (refreshToken == "") {
        AppNotifier.logWithScreen("SharedRefreshToken missing", "User must login again");
        return null;
      }

      final TokenResponse result = await appAuth.token(
        TokenRequest(
          EnvConfig.msClientId,
          EnvConfig.msRedirectUri,
          discoveryUrl:
          "https://login.microsoftonline.com/${EnvConfig.msTenantId}/v2.0/.well-known/openid-configuration",
          refreshToken: refreshToken,
          scopes: [
            "https://alsanidi-my.sharepoint.com/.default"
          ],
        ),
      );

      if (result.accessToken == null) {
        AppNotifier.logWithScreen("MySharedRefreshToken failed", "Null token response");
        return null;
      }

      // Save tokens again
      await secureStorage.saveData("MySharePointAccessToken", result.accessToken!);
      if (result.refreshToken != null) {
        await secureStorage.saveData("RefreshToken", result.refreshToken!);
      }
      await secureStorage.saveData("MySharedTokenSavedAt", DateTime.now().toIso8601String());

      return result.accessToken!;
    } catch (e) {
      AppNotifier.logWithScreen('MySharedRefreshToken token failed', '$e');
    }
    return null;
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    return await dio.get(endpoint, queryParameters: queryParams);
  }
}
