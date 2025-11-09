import 'package:aad_oauth/aad_oauth.dart';
import 'package:flutter/material.dart';

import '../utils/export_import.dart';

class AuthControllerOld {
  final BuildContext context;
  late final AadOAuth? oauth;
  final SecureStorageService secureStorage = SecureStorageService();
  final BiometricAuthController biometricAuth = BiometricAuthController();

  AuthControllerOld({
    required this.context,
    this.oauth,
  });

  void setOauth(AadOAuth newOauth) {
    oauth = newOauth;
  }

  Future<bool> loginMicrosoftOnce() async {
    try {
      await secureStorage.deleteData();

      await oauth!.login();

      final accessToken = await oauth!.getAccessToken();

      if (accessToken == null) {
        _showError("Login failed: No access token");
        return false;
      }

      // ✅ حفظ التوكن
      await secureStorage.saveData("AccessToken", accessToken);
      await secureStorage.saveData(
        "TokenSavedAt",
        DateTime.now().toIso8601String(),
      );

      AppNotifier.logWithScreen("Auth", "✅ Login successful via AadOAuth");

      return true;

    } catch (e) {
      _showError("Login error: $e");
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final token = await oauth!.getAccessToken();

      if (token == null) {
        _showError("Token expired, please login again");
        return null;
      }

      // ✅ حفظ التوكن للتطبيق
      await secureStorage.saveData("AccessToken", token);
      return token;

    } catch (e) {
      _showError("Token error: $e");
      return null;
    }
  }

  /// ✅ Biometric Login
  Future<bool> loginWithBiometrics() async {
    final ok = await biometricAuth.authenticateWithBiometrics();
    return ok;
  }

  /// ✅ Error handler
  void _showError(String msg) {
    AppNotifier.logWithScreen("Auth Controller", "Error: $msg");
    AppNotifier.snackBar(context, msg, SnackBarType.error);
  }
}

