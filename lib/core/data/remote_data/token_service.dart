import 'package:flutter_appauth/flutter_appauth.dart';

import '../../../utils/app_notifier.dart';
import '../../config/env_config.dart';
import '../../service/secure_storage_service.dart';

class TokenService{
  static final SecureStorageService secureStorage = SecureStorageService();
  static const FlutterAppAuth appAuth = FlutterAppAuth();

  static Future<bool> isGraphTokenExpired(
      {Duration expiryDuration = const Duration(hours: 1)}) async {
    String? savedAtStr = await secureStorage.getData("TokenSavedAt");
    if (savedAtStr == "") return true;

    final savedAt = DateTime.tryParse(savedAtStr);
    if (savedAt == null) return true;
    AppLogger.info("GraphDioClient", "savedAt: $savedAt");

    final now = DateTime.now();
    final expiryTime = savedAt.add(expiryDuration);
    return now.isAfter(expiryTime);
  }

  static Future<String?> refreshGraphToken() async {
    try {
      final refreshToken = await secureStorage.getData("RefreshToken");
      if (refreshToken == "") {
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
            "openid",
            "profile",
            "User.read",
            "offline_access",
            "https://graph.microsoft.com/.default"
          ],
        ),
      );

      if (result.accessToken == null) {
        return null;
      }

      // Save tokens again
      await secureStorage.saveData("GraphAccessToken", result.accessToken!);
      if (result.refreshToken != null) {
        await secureStorage.saveData("RefreshToken", result.refreshToken!);
      }
      await secureStorage.saveData("TokenSavedAt", DateTime.now().toIso8601String());
      return result.accessToken!;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<bool> isSpTokenExpired({Duration expiryDuration = const Duration(hours: 1)}) async {
    String? savedAtStr = await secureStorage.getData("SPTokenSavedAt");
    if (savedAtStr == "") return true;

    final savedAt = DateTime.tryParse(savedAtStr);
    if (savedAt == null) return true;
    final now = DateTime.now();
    final expiryTime = savedAt.add(expiryDuration);
    return now.isAfter(expiryTime);
  }

  static Future<String?> refreshSpToken() async {
    try {
      final refreshToken = await secureStorage.getData("RefreshToken");

      if (refreshToken == "") return null;

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

      if (result.accessToken == null) return null;

      await secureStorage.saveData("SPAccessToken", result.accessToken!);
      if (result.refreshToken != null) {
        await secureStorage.saveData("RefreshToken", result.refreshToken!);
      }
      await secureStorage.saveData("SPTokenSavedAt", DateTime.now().toIso8601String());

      return result.accessToken!;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<bool> isMyShareTokenExpired(
      {Duration expiryDuration = const Duration(hours: 1)}) async {
    String? savedAtStr = await secureStorage.getData("MySPTokenSavedAt");

    if (savedAtStr == "") return true;

    final savedAt = DateTime.tryParse(savedAtStr);
    if (savedAt == null) return true;

    final now = DateTime.now();
    final expiryTime = savedAt.add(expiryDuration);
    return now.isAfter(expiryTime);
  }

  static Future<String?> refreshMyShareToken() async {
    try {
      final refreshToken = await secureStorage.getData("RefreshToken");

      if (refreshToken == "") return null;


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

      if (result.accessToken == null) return null;

      await secureStorage.saveData("MySPAccessToken", result.accessToken!);
      if (result.refreshToken != null) {
        await secureStorage.saveData("RefreshToken", result.refreshToken!);
      }
      await secureStorage.saveData(
          "MySPTokenSavedAt", DateTime.now().toIso8601String());
      return result.accessToken!;
    } catch (e) {
      throw e.toString();
    }
  }
}