import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import '../utils/export_import.dart';
import 'package:http/http.dart' as http;

class AuthController {
  final FlutterAppAuth appAuth = const FlutterAppAuth();
  final BuildContext context;
  final SecureStorageService secureStorage = SecureStorageService();
  final BiometricAuthController biometricAuth = BiometricAuthController();

  AuthController({required this.context});

  // Future<bool> loginMicrosoftOnce() async {
  //   try {
  //     // 1️⃣ Clear previous session
  //     await _clearPreviousSession();
  //
  //     final clientId = EnvConfig.msClientId;
  //     const redirectUri = "com.alsanidi.sndpower://oauthredirect";
  //     final tenant = EnvConfig.msTenantId;
  //
  //     final scope = [
  //       "openid",
  //       "profile",
  //       "email",
  //       "offline_access",
  //     ].join(" ");
  //
  //
  //     final authUrl =
  //         "https://login.microsoftonline.com/$tenant/oauth2/v2.0/authorize"
  //         "?client_id=$clientId"
  //         "&response_type=code"
  //         "&redirect_uri=${Uri.encodeComponent(redirectUri)}"
  //         "&scope=${Uri.encodeComponent(scope)}"
  //         "&response_mode=query"
  //         "&prompt=select_account"; // إجبار اختيار الحساب
  //
  //     print("AuthUrl: $authUrl");
  //
  //
  //     final result = await FlutterWebAuth2.authenticate(
  //       url: authUrl,
  //       callbackUrlScheme: "com.alsanidi.sndpower",
  //     );
  //
  //     final code = Uri.parse(result).queryParameters['code'];
  //     if (code == null) {
  //       _showError("Login failed: No authorization code returned");
  //       return false;
  //     }
  //
  //     final tokenUrl =
  //         "https://login.microsoftonline.com/$tenant/oauth2/v2.0/token";
  //
  //     final response = await http.post(
  //       Uri.parse(tokenUrl),
  //       headers: {"Content-Type": "application/x-www-form-urlencoded"},
  //       body: {
  //         "client_id": clientId,
  //         "grant_type": "authorization_code",
  //         "code": code,
  //         "redirect_uri": redirectUri,
  //       },
  //     );
  //
  //     final tokenData = jsonDecode(response.body);
  //
  //     if (!tokenData.containsKey("refresh_token")) {
  //       _showError("Login failed: No refresh token received");
  //       return false;
  //     }
  //
  //     final refreshToken = tokenData["refresh_token"];
  //
  //     // 7️⃣ حفظ الـ refresh token
  //     await secureStorage.saveData("RefreshToken", refreshToken);
  //     await secureStorage.saveData(
  //         "TokenSavedAt", DateTime.now().toIso8601String());
  //
  //     AppNotifier.logWithScreen(
  //         "Auth Controller", "✅ Login successful, refresh token saved.");
  //
  //     return true;
  //   } catch (e) {
  //     _showError("Login error: $e");
  //     return false;
  //   }
  // }

  Future<bool> loginMicrosoftOnceOld() async {
    try {
      await _clearPreviousSession();

      final clientId = EnvConfig.msClientId;
      final redirectUri = EnvConfig.msRedirectUri;
      final tenant = EnvConfig.msTenantId;

      final scope = [
        "openid",
        "profile",
        "email",
        "offline_access",
      ].join(" ");

      final authUrl =
          "https://login.microsoftonline.com/$tenant/oauth2/v2.0/authorize"
          "?client_id=$clientId"
          "&response_type=code"
          "&redirect_uri=$redirectUri"
          "&scope=${Uri.encodeComponent(scope)}"
          "&response_mode=query"
          "&prompt=select_account";

      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: "com.alsanidi.sndpower",
      );

      // Extract authorization code
      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) {
        _showError("Login failed: No authorization code returned");
        return false;
      }

      // Exchange the code for access + refresh tokens
      final tokenUrl =
          "https://login.microsoftonline.com/$tenant/oauth2/v2.0/token";

      final response = await http.post(
        Uri.parse(tokenUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "client_id": clientId,
          "grant_type": "authorization_code",
          "code": code,
          "redirect_uri": redirectUri,
        },
      );

      final tokenData = jsonDecode(response.body);

      if (!tokenData.containsKey("refresh_token")) {
        _showError("Login failed: No refresh token received");
        return false;
      }

      final refreshToken = tokenData["refresh_token"];

      // Save refresh token
      await secureStorage.saveData("RefreshToken", refreshToken);
      await secureStorage.saveData(
          "TokenSavedAt", DateTime.now().toIso8601String());

      AppNotifier.logWithScreen(
          "Auth Controller", "✅ Login successful, refresh token saved.");

      return true;
    } catch (e) {
      _showError("Login error: $e");
      return false;
    }
  }

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
          externalUserAgent: ExternalUserAgent.ephemeralAsWebAuthenticationSession,
          allowInsecureConnections: Platform.isAndroid
        ),
      );

      if (result.refreshToken == null) {
        _showError("Login failed: No refresh token received");
        return false;
      }

      // ✅ Save refresh token
      await secureStorage.saveData("RefreshToken", result.refreshToken!);
      await secureStorage.saveData(
          "TokenSavedAt", DateTime.now().toIso8601String());

      AppNotifier.logWithScreen(
          "Auth Controller", "✅ Login successful, refresh token saved.");
      return true;
    } catch (e) {
      _showError("Login error: $e");
      return false;
    }
  }

  Future<String?> getGraphToken() async {
    try {
      final refreshToken = await secureStorage.getData("RefreshToken");
      if (refreshToken == "") {
        _showError("No refresh token found, login required");
        return null;
      }

      final result = await appAuth.token(
        TokenRequest(
          EnvConfig.msClientId,
          EnvConfig.msRedirectUri,
          refreshToken: refreshToken,
          discoveryUrl:
              "https://login.microsoftonline.com/${EnvConfig.msTenantId}/v2.0/.well-known/openid-configuration",
          scopes: ["https://graph.microsoft.com/.default"],
        ),
      );

      final accessToken = result.accessToken;
      if (accessToken != null) {
        await secureStorage.saveData("GraphAccessToken", accessToken);
        AppNotifier.logWithScreen("Auth Controller", "✅ Graph token retrieved");
      }
      return accessToken;
    } catch (e) {
      _showError("Graph token error: $e");
      return null;
    }
  }

  Future<String?> getSharePointToken() async {
    try {
      final refreshToken = await secureStorage.getData("RefreshToken");

      if (refreshToken == "") {
        _showError("No refresh token found, login required");
        return null;
      }

      final result = await appAuth.token(
        TokenRequest(
          EnvConfig.msClientId,
          EnvConfig.msRedirectUri,
          refreshToken: refreshToken,
          discoveryUrl:
              "https://login.microsoftonline.com/${EnvConfig.msTenantId}/v2.0/.well-known/openid-configuration",
          scopes: ["https://alsanidi.sharepoint.com/.default"],
        ),
      );

      final accessToken = result.accessToken;
      if (accessToken != null) {
        await secureStorage.saveData("SPAccessToken", accessToken);
        AppNotifier.logWithScreen(
            "Auth Controller", "✅ SharePoint token retrieved");
      }
      return accessToken;
    } catch (e) {
      _showError("SharePoint token error: $e");
      return null;
    }
  }

  Future<String?> getMySharePointToken() async {
    try {
      final refreshToken = await secureStorage.getData("RefreshToken");

      if (refreshToken == "") {
        _showError("No refresh token found, login required");
        return null;
      }

      final result = await appAuth.token(
        TokenRequest(
          EnvConfig.msClientId,
          EnvConfig.msRedirectUri,
          refreshToken: refreshToken,
          discoveryUrl:
              "https://login.microsoftonline.com/${EnvConfig.msTenantId}/v2.0/.well-known/openid-configuration",
          scopes: ["https://alsanidi-my.sharepoint.com/.default"],
        ),
      );

      final accessToken = result.accessToken;
      if (accessToken != null) {
        await secureStorage.saveData("MySPAccessToken", accessToken);
        AppNotifier.logWithScreen(
            "Auth Controller", "✅ MySharePoint token retrieved");
      }
      return accessToken;
    } catch (e) {
      _showError("MySharePoint token error: $e");
      return null;
    }
  }

  Future<void> _clearPreviousSession() async {
    await secureStorage.deleteData();
  }

  void _showError(String message) {
    AppNotifier.logWithScreen("Auth Controller", "LoginError: $message");
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
