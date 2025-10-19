import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../config/env_config.dart';
import '../utils/app_notifier.dart';
import 'biometric_auth_controller.dart';
import '../utils/enums.dart';
import '../service/secure_storage_service.dart';

class AuthController {
  final FlutterAppAuth appAuth = const FlutterAppAuth();
  final BuildContext context;
  final SecureStorageService secureStorage = SecureStorageService();
  final BiometricAuthController biometricAuth = BiometricAuthController();

  AuthController({
    required this.context,
  });

  Future<bool> getSharePointToken() async {
    try {
      final result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          EnvConfig.msClientId,
          EnvConfig.msRedirectUri,
          discoveryUrl:
          "https://login.microsoftonline.com/${EnvConfig.msTenantId}/v2.0/.well-known/openid-configuration",
          scopes: [
            "openid",
            "profile",
            "offline_access",
            "https://alsanidi.sharepoint.com/.default" // important
          ],
          promptValues: ["select_account"],
        ),
      );
      AppNotifier.logWithScreen("Old Auth Controller", "✅ SharePoint token: ${result.accessToken}");

      final decoded = parseJwt(result.accessToken!);
      AppNotifier.logWithScreen("Old Auth Controller","✅ SharePoint Audience: ${decoded['aud']}");
      AppNotifier.logWithScreen("Old Auth Controller","✅ SharePoint Audience: ${decoded['aud']}");

      if (result.accessToken == null) {
        _showError("SharedPoint Login failed: No token received");
        return false;
      }
      await secureStorage.saveData("SharedAccessToken", result.accessToken!);
      if (result.refreshToken != null) {
        await secureStorage.saveData("SharedRefreshToken", result.refreshToken!);
      }
      await secureStorage.saveData("SPTokenSavedAt", DateTime.now().toIso8601String());

      return true;
    } catch (e) {
      _showError("SharePoint login error: $e");
      return false;
    }
  }

  Future<bool> getGraphToken() async {
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
            "offline_access",
            "https://graph.microsoft.com/.default"
          ],
          promptValues: ["select_account"],
        ),
      );

      AppNotifier.logWithScreen("Old Auth Controller","✅ Graph token: ${result.accessToken}");

      final decoded = parseJwt(result.accessToken!);
      AppNotifier.logWithScreen("Old Auth Controller","✅ Graph Audience: ${decoded['aud']}");

      if (result.accessToken == null) {
        _showError("Graph Login failed: No token received");
        return false;
      }
      await secureStorage.saveData("GraphAccessToken", result.accessToken!);
      if (result.refreshToken != null) {
        await secureStorage.saveData("GraphRefreshToken", result.refreshToken!);
      }
      await secureStorage.saveData(
          "TokenSavedAt", DateTime.now().toIso8601String());

      return true;
    } catch (e) {
      _showError("Graph login error: $e");
      return false;
    }
  }

  Future<bool> handleMicrosoftLogin() async {
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
          promptValues: ["select_account"], // يضمن إن صفحة تسجيل الدخول تفتح
        ),
      );

      if (result.accessToken == null) {
        _showError("Login failed: No token received");
        return false;
      }

      // ✅ Save tokens
      await secureStorage.saveData("AccessToken", result.accessToken!);
      if (result.refreshToken != null) {
        await secureStorage.saveData("RefreshToken", result.refreshToken!);
      }
      await secureStorage.saveData(
          "TokenSavedAt", DateTime.now().toIso8601String());

      // ✅ Decode IdToken (optional)
      if (result.idToken != null) {
        final decoded = parseJwt(result.idToken!);
        final email = decoded["preferred_username"] ?? decoded["email"];
        decoded.forEach((key, value) {
          AppNotifier.logWithScreen("Old Auth Controller","Decoded $key: $value");
        });
        AppNotifier.logWithScreen("Old Auth Controller","IdToken Email: $email");
      }

      return true;
    } catch (e) {
      _showError("Login error: $e");
      return false;
    }
  }

  Future<void> _clearPreviousSession() async {
    await secureStorage.deleteData();
  }

  void _showError(String message) {
    AppNotifier.logWithScreen("Old Auth Controller","LoginError: $message");
    AppNotifier.snackBar(context, message, SnackBarType.error);
  }

  Future<bool> loginWithBiometrics() async {
    final authenticated = await biometricAuth.authenticateWithBiometrics();
    if (!authenticated) return false;

    final token = await secureStorage.getData("AccessToken");
    if (token == "") {
      _showError("No saved token, please login with Microsoft first");
      return false;
    }
    return true;
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
}