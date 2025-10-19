import 'dart:async';
import 'dart:ui';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/service/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../config/env_config.dart';

class SharePointDioClient {
  late final Dio dio;
  final FlutterAppAuth appAuth;
  final SecureStorageService secureStorage = SecureStorageService();
  final VoidCallback onUnauthorized;
  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  static const int _maxRetryCount = 1;

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
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          final requestOptions = error.requestOptions;

          AppNotifier.logWithScreen(
            "SharePoint DioClient Error",
            "Code: $statusCode | Message: ${error.message} | Path: ${requestOptions.path}",
          );

          int retryCount = requestOptions.extra["retryCount"] ?? 0;
          if (retryCount >= _maxRetryCount) {
            AppNotifier.logWithScreen("SharePoint DioClient",
                "Max retry reached, not retrying request.");
            return handler.next(error);
          }

          if (statusCode == 401 || statusCode == 403) {
            AppNotifier.logWithScreen("SharePoint DioClient",
                "Token invalid, trying to refresh... (attempt ${retryCount + 1})");

            // في حال هناك refresh شغال، ننتظر نتيجته
            if (_isRefreshing) {
              AppNotifier.logWithScreen("SharePoint DioClient",
                  "Refresh already in progress, waiting...");
              final waitingToken = await _refreshCompleter?.future;

              if (waitingToken == null) {
                AppNotifier.logWithScreen("SharePoint DioClient",
                    "Waiting finished but no valid token, forcing logout.");
                AppNotifier.logWithScreen("SharePoint DioClient", "انتهت الجلسة، يرجى تسجيل الدخول مجددًا");
                onUnauthorized();
                return;
              }

              requestOptions.extra["retryCount"] = retryCount + 1;
              requestOptions.headers['Authorization'] = 'Bearer $waitingToken';
              final clonedResponse = await dio.fetch(requestOptions);
              return handler.resolve(clonedResponse);
            }

            // عملية refresh جديدة
            _isRefreshing = true;
            _refreshCompleter = Completer<String?>();

            try {
              final newToken = await _refreshToken();
              _isRefreshing = false;

              if (newToken != null) {
                _refreshCompleter?.complete(newToken);
                AppNotifier.logWithScreen("SharePoint DioClient",
                    "Token refreshed successfully, retrying request...");
                requestOptions.extra["retryCount"] = retryCount + 1;
                requestOptions.headers['Authorization'] = 'Bearer $newToken';
                final clonedResponse = await dio.fetch(requestOptions);
                return handler.resolve(clonedResponse);
              } else {
                _refreshCompleter?.complete(null);
                AppNotifier.logWithScreen("SharePoint DioClient",  "انتهت الجلسة، يرجى تسجيل الدخول مجددًا");
                AppNotifier.logWithScreen("SharePoint DioClient",
                    "Token refresh failed, user must login again.");
                onUnauthorized();
                return;
              }
            } catch (e) {
              _isRefreshing = false;
              _refreshCompleter?.completeError(e);
              AppNotifier.logWithScreen("SharePoint DioClient", "Token refresh error: $e");
              AppNotifier.logWithScreen("SharePoint DioClient", "حدث خطأ في الاتصال، يرجى تسجيل الدخول مجددًا");
              onUnauthorized();
              return;
            }
          }

          return handler.next(error);
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

  Future<String?> _refreshToken({BuildContext? context}) async {
    try {
      AppNotifier.showLoading(
          context, "جارٍ إعادة الاتصال بخادم SharePoint...");

      final refreshToken = await secureStorage.getData("RefreshToken");

      if (refreshToken == "") {
        AppNotifier.logWithScreen(
            "SharePoint RefreshToken", "Missing refresh token, need login");
        AppNotifier.hideLoading(context);
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

      AppNotifier.hideLoading(context);

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
      AppNotifier.hideLoading(context);
      AppNotifier.logWithScreen("SharePoint RefreshToken", "Error: $e");
      return null;
    }
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
