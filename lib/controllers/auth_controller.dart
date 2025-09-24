import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../config/env_config.dart';
import '../utils/app_notifier.dart';
import '../utils/biomertic_auth.dart';
import '../utils/enums.dart';
import '../service/secure_storage_service.dart';

// redirect_uri="msauth://com.alsanidi.company_portal/LosFLVyyTnw%2B0SkLIA3%2Bil9WsBE%3D",
class AuthController {
  final FlutterAppAuth appAuth = const FlutterAppAuth();
  final BuildContext context;
  final SecureStorageService secureStorage = SecureStorageService();
  final BiometricAuth biometricAuth = BiometricAuth();

  AuthController({required this.context});

  /// تسجيل الدخول مرة واحدة فقط
  Future<bool> loginMicrosoftOnce() async {
    try {
      await _clearPreviousSession();

      final result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          EnvConfig.msClientId,
          EnvConfig.msRedirectUri,
          discoveryUrl:
          "https://login.microsoftonline.com/${EnvConfig.msTenantId}/v2.0/.well-known/openid-configuration",
          scopes: [
            "openid",
            "profile",
            "email",
            "offline_access",
          ],
          promptValues: ["select_account"],
        ),
      );

      if (result == null || result.refreshToken == null) {
        _showError("Login failed: No refresh token received");
        return false;
      }

      // ✅ Save refresh token
      await secureStorage.saveData("RefreshToken", result.refreshToken!);
      await secureStorage.saveData(
          "TokenSavedAt", DateTime.now().toIso8601String());

      print("✅ Login successful, refresh token saved.");
      return true;
    } catch (e) {
      _showError("Login error: $e");
      return false;
    }
  }

  /// احصل على Graph Token باستخدام refresh token
  Future<String?> getGraphToken() async {
    try {
      final refreshToken = await secureStorage.getData("RefreshToken");
      if (refreshToken == null) {
        _showError("No refresh token found, login required");
        return null;
      }

      final result = await appAuth.token(TokenRequest(
        EnvConfig.msClientId,
        EnvConfig.msRedirectUri,
        refreshToken: refreshToken,
        discoveryUrl:
        "https://login.microsoftonline.com/${EnvConfig.msTenantId}/v2.0/.well-known/openid-configuration",
        scopes: ["https://graph.microsoft.com/.default"],
      ));

      final accessToken = result.accessToken;
      if (accessToken != null) {
        await secureStorage.saveData("GraphAccessToken", accessToken);
        print("✅ Graph token retrieved");
      }
      return accessToken;
    } catch (e) {
      _showError("Graph token error: $e");
      return null;
    }
  }

  /// احصل على SharePoint Token باستخدام refresh token
  Future<String?> getSharePointToken() async {
    try {
      final refreshToken = await secureStorage.getData("RefreshToken");
      if (refreshToken == null) {
        _showError("No refresh token found, login required");
        return null;
      }

      final result = await appAuth.token(TokenRequest(
        EnvConfig.msClientId,
        EnvConfig.msRedirectUri,
        refreshToken: refreshToken,
        discoveryUrl:
        "https://login.microsoftonline.com/${EnvConfig.msTenantId}/v2.0/.well-known/openid-configuration",
        scopes: ["https://alsanidi.sharepoint.com/.default"],
      ));

      final accessToken = result?.accessToken;
      if (accessToken != null) {
        await secureStorage.saveData("SharePointAccessToken", accessToken);
        print("✅ SharePoint token retrieved");
      }
      return accessToken;
    } catch (e) {
      _showError("SharePoint token error: $e");
      return null;
    }
  }

  Future<void> _clearPreviousSession() async {
    await secureStorage.deleteData();
  }

  void _showError(String message) {
    print("LoginError: $message");
    AppNotifier.snackBar(context, message, SnackBarType.error);
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token');
    }

    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return json.decode(decoded) as Map<String, dynamic>;
  }

  Future<bool> loginWithBiometrics() async {
    final authenticated = await biometricAuth.authenticateWithBiometrics();
    if (!authenticated) return false;

    return true;
  }

}

