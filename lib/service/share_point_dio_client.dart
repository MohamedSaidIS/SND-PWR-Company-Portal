import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../../../../utils/export_import.dart';

class SharePointDioClient {
  late final Dio dio;
  final FlutterAppAuth appAuth;
  final SecureStorageService secureStorage = SecureStorageService();
  final VoidCallback onUnauthorized;

  SharePointDioClient({
    required this.appAuth,
    required this.onUnauthorized,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.spBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await secureStorage.getData("SPAccessToken");

          final expired = await isTokenExpired();
          AppNotifier.logWithScreen(
              "SharePoint DioClient", "SPAccessToken expired: $expired");

          if (expired) {
            token = await _refreshToken();
            AppNotifier.logWithScreen("SharePoint DioClient",
                "New SPAccessToken after refresh: $token");
          }

          if (token == null) {
            AppNotifier.logWithScreen("SharePoint DioClient",
                "The session has expired, please log in again.");
            onUnauthorized();
            return;
          }

          options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
        onError: (error, handler) {
          AppNotifier.logWithScreen("SharePoint DioClient","⚠️ Unauthorized called! before");
          if (error.response?.statusCode == 401) {
            AppNotifier.logWithScreen("SharePoint DioClient","⚠️ Unauthorized called! after");
            AppNotifier.logWithScreen("SharePoint DioClient","Graph AccessToken Expired And Error 401");
            onUnauthorized();
          }
          handler.next(error);
        },
      ),
    );
  }


  Future<bool> isTokenExpired({Duration expiryDuration = const Duration(hours: 1)}) async {
    String? savedAtStr = await secureStorage.getData("SPTokenSavedAt");
    AppNotifier.logWithScreen("SharePoint DioClient", "Date: $savedAtStr");

    if (savedAtStr == "") return true;

    final savedAt = DateTime.tryParse(savedAtStr);
    if (savedAt == null) return true;
    AppNotifier.logWithScreen("SharePoint DioClient", "savedAt: $savedAt");

    final now = DateTime.now();
    final expiryTime = savedAt.add(expiryDuration);
    return now.isAfter(expiryTime);
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await secureStorage.getData("RefreshToken");

      if (refreshToken == "") {
        AppNotifier.logWithScreen(
            "SharePoint RefreshToken", "Missing refresh token, need login");
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
            "https://alsanidi.sharepoint.com/.default",
            "offline_access",
          ],
        ),
      );

      if (result.accessToken == null) {
        AppNotifier.logWithScreen(
            "SharePoint RefreshToken", "Null token result");
        return null;
      }

      await secureStorage.saveData("SPAccessToken", result.accessToken!);
      if (result.refreshToken != null) {
        await secureStorage.saveData("RefreshToken", result.refreshToken!);
      }
      await secureStorage.saveData(
          "SPTokenSavedAt", DateTime.now().toIso8601String());

      return result.accessToken!;
    } catch (e) {
      AppNotifier.logWithScreen("SharePoint RefreshToken", "Error: $e");
    }
    return null;
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    return await dio.get(endpoint, queryParameters: queryParams);
  }

  Future<Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
    BuildContext? context,
  }) async {
    return await dio.post(
      endpoint,
      data: data,
      options: Options(extra: {"context": context}),
    );
  }
}
