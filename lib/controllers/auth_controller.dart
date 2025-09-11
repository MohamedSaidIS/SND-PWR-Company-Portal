import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../config/env_config.dart';
import '../utils/app_notifier.dart';
import '../utils/biomertic_auth.dart';
import '../utils/enums.dart';
import '../utils/secure_storage_service.dart';

class AuthController {
  final FlutterAppAuth appAuth = const FlutterAppAuth();
  final BuildContext context;
  final SecureStorageService secureStorage = SecureStorageService();
  final BiometricAuth biometricAuth = BiometricAuth();

  AuthController({
    required this.context,
  });


  Future<bool> handleMicrosoftLogin() async {
    try {
      await _clearPreviousSession();

      final result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          EnvConfig.msClientId,
          EnvConfig.msRedirectUri,
          discoveryUrl:
          "https://login.microsoftonline.com/${EnvConfig.msTenantId}/v2.0/.well-known/openid-configuration",
          scopes: ["openid", "profile", "email", "offline_access"],
          promptValues: ["select_account"], // يضمن إن صفحة تسجيل الدخول تفتح

        ),
      );

      if (result == null || result.accessToken == null) {
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
          print("Decoded $key: $value");
        });
        print("IdToken Email: $email");
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
    AppNotifier.snackBar(context, message, SnackBarType.error);
  }


  Future<bool> loginWithBiometrics() async {
    final authenticated = await biometricAuth.authenticateWithBiometrics();
    if(!authenticated) return false;

    final token = await secureStorage.getData("AccessToken");
    if (token == null) {
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
