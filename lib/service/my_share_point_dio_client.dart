
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/service/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../config/env_config.dart';

class MySharePointDioClient {
  late final Dio dio;
  final FlutterAppAuth appAuth;
  final SecureStorageService secureStorage = SecureStorageService();
  final VoidCallback onUnauthorized;
  bool _isRefreshing = false;

  static const int _maxRetryCount = 1;

  MySharePointDioClient({required this.appAuth, required this.onUnauthorized}) {
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
          String? token = await secureStorage.getData("MySPAccessToken");

          final expired = await isTokenExpired();
          AppNotifier.logWithScreen(
              "MySharePoint DioClient", "MySPAccessToken expired: $expired");

          if (expired) {
            token = await _refreshToken();
            AppNotifier.logWithScreen("MySharePoint DioClient",
                "New MySPAccessToken after refresh: $token");
          }

          if (token == null) {
            AppNotifier.logWithScreen("MySharePoint DioClient",
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

          AppNotifier.logWithScreen("MySharePoint DioClient Error",
              "Code: $statusCode | Message: ${error
                  .message} | Path: ${requestOptions.path}");

          int retryCount = requestOptions.extra["retryCount"] ?? 0;
          if (retryCount >= _maxRetryCount) {
            AppNotifier.logWithScreen("MySharePoint DioClient",
                "Max retry reached, not retrying request.");
            return handler.next(error);
          }

          if (statusCode == 401 || statusCode == 403) {
            AppNotifier.logWithScreen("MySharePoint DioClient",
                "Token invalid, trying to refresh... (attempt ${retryCount +
                    1})");

            if (_isRefreshing) {
              AppNotifier.logWithScreen("MySharePoint DioClient",
                  "Refresh already in progress, waiting...");
              await Future.delayed(
                const Duration(seconds: 2),
              );
              return handler.next(error);
            }

            _isRefreshing = true;
            final newToken = await _refreshToken();
            _isRefreshing = false;

            if (newToken != null) {
              requestOptions.extra["retryCount"] = retryCount + 1;
              requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final clonedResponse = await dio.fetch(requestOptions);
              return handler.resolve(clonedResponse);
            } else {
              AppNotifier.logWithScreen("MySharePoint DioClient",
                  "The session has expired, please log in again.");
              onUnauthorized();
              return;
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> isTokenExpired(
      {Duration expiryDuration = const Duration(hours: 1)}) async {
    String? savedAtStr = await secureStorage.getData("MySPTokenSavedAt");
    AppNotifier.logWithScreen("MySharePoint DioClient", "Date: $savedAtStr");

    if (savedAtStr == "") return true;

    final savedAt = DateTime.tryParse(savedAtStr);
    if (savedAt == null) return true;
    AppNotifier.logWithScreen("MySharePoint DioClient", "savedAt: $savedAt");

    final now = DateTime.now();
    final expiryTime = savedAt.add(expiryDuration);
    return now.isAfter(expiryTime);
  }

  Future<String?> _refreshToken({BuildContext? context}) async {
    try {
      AppNotifier.showLoading(
          context, "جارٍ إعادة الاتصال بخادم MySharePoint...");

      final refreshToken = await secureStorage.getData("RefreshToken");

      if (refreshToken == "") {
        AppNotifier.logWithScreen(
            "MySharePoint RefreshToken", "Missing refresh token, need login");
        AppNotifier.hideLoading(context);
        return null;
      }

      final TokenResponse result = await appAuth.token(
        TokenRequest(
          EnvConfig.msClientId,
          EnvConfig.msRedirectUri,
          discoveryUrl:
          "https://login.microsoftonline.com/${EnvConfig
              .msTenantId}/v2.0/.well-known/openid-configuration",
          refreshToken: refreshToken,
          scopes: [
            "https://alsanidi-my.sharepoint.com/.default",
            "offline_access",
          ],
        ),
      );

      AppNotifier.hideLoading(context);

      if (result.accessToken == null) {
        AppNotifier.logWithScreen(
            "MySharePoint RefreshToken", "Null token result");
        return null;
      }

      await secureStorage.saveData("MySPAccessToken", result.accessToken!);
      if (result.refreshToken != null) {
        await secureStorage.saveData("RefreshToken", result.refreshToken!);
      }
      await secureStorage.saveData(
          "MySPTokenSavedAt", DateTime.now().toIso8601String());

      return result.accessToken!;
    } catch (e) {
      AppNotifier.hideLoading(context);
      AppNotifier.logWithScreen("MySharePoint RefreshToken", "Error: $e");
      return null;
    }
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    return await dio.get(endpoint, queryParameters: queryParams);
  }

  Future<Response> post(String endpoint, {
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
