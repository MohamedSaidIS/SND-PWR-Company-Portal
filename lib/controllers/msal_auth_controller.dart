// import 'package:company_portal/config/auth_controller.dart';
// import 'package:flutter/material.dart';
// import '../utils/export_import.dart';
//
// class MsalAuthController {
//   final BuildContext context;
//   final AuthConfigController oauth;
//   final SecureStorageService secureStorage = SecureStorageService();
//   final BiometricAuthController biometricAuth = BiometricAuthController();
//
//   MsalAuthController({required this.context, required this.oauth});
//
//   Future<bool> loginMicrosoftOnce() async {
//     try {
//       await oauth.refreshOAuth.logout();
//
//        await oauth.refreshOAuth.login();
//
//       final result  = await oauth.refreshOAuth.refreshToken();
//       result.fold(
//             (failure) => _showError(failure.toString()),
//             (token) async {
//             //  _showError('Logged in successfully, your access token: $token');
//               await secureStorage.saveData("RefreshToken", "$token");
//               await secureStorage.saveData("TokenSavedAt", DateTime.now().toIso8601String());
//               AppNotifier.logWithScreen("Auth Controller", "✅ Login successful");
//             }
//       );
//       return true;
//     } catch (e) {
//       _showError("Login error: $e");
//       return false;
//     }
//   }
//
//   Future<String?> getGraphToken() async {
//     try {
//       final token = await oauth.graphOAuth.getAccessToken();
//       if (token == null) {
//         _showError("No token found, login required");
//         return null;
//       }
//       await secureStorage.saveData("GraphAccessToken", token);
//       AppNotifier.logWithScreen("GraphDioClient","Graph AccessToken MsalController $token");
//       return token;
//     } catch (e) {
//       _showError("Graph token error: $e");
//       return null;
//     }
//   }
//
//   Future<String?> getSharePointToken() async {
//     try {
//       final token = await oauth.spOAuth.getAccessToken();
//       if (token == null) {
//         _showError("No token found, login required");
//         return null;
//       }
//       await secureStorage.saveData("SPAccessToken", token);
//
//       return token;
//     } catch (e) {
//       _showError("SharePoint token error: $e");
//       return null;
//     }
//   }
//
//
//   Future<String?> getMySharePointToken() async {
//     try {
//       final token = await oauth.mySpOAuth.getAccessToken();
//       if (token == null) {
//         _showError("No token found, login required");
//         return null;
//       }
//       await secureStorage.saveData("MySPAccessToken", token);
//       return token;
//     } catch (e) {
//       _showError("MySharePoint token error: $e");
//       return null;
//     }
//   }
//
//   void _showError(String message) {
//     AppNotifier.logWithScreen("Auth Controller", message);
//     AppNotifier.snackBar(context, message, SnackBarType.error);
//   }
//
//   Future<void> logout() async {
//     await oauth.graphOAuth.logout();
//     await oauth.spOAuth.logout();
//     await oauth.mySpOAuth.logout();
//     await secureStorage.deleteData();
//   }
//
//   Future<bool> loginWithBiometrics() async {
//     final authenticated = await biometricAuth.authenticateWithBiometrics();
//     return authenticated;
//   }
//
// }


import 'package:flutter/material.dart';
import '../utils/export_import.dart';

class MsalAuthController {
  final BuildContext context;
  final AuthConfigController oauth;
  final SecureStorageService secureStorage = SecureStorageService();
  final BiometricAuthController biometricAuth = BiometricAuthController();

  MsalAuthController({required this.context, required this.oauth});

  /// تسجيل الدخول لمرة واحدة مع حفظ refresh token
  Future<bool> loginMicrosoftOnce() async {
    try {
      await oauth.refreshOAuth.logout();
      await oauth.refreshOAuth.login();

      final result = await oauth.refreshOAuth.refreshToken();
      result.fold(
            (failure) => _showError(failure.toString()),
            (token) async {
          await secureStorage.saveData("RefreshToken", "$token");
          await secureStorage.saveData(
              "TokenSavedAt", DateTime.now().toIso8601String());
          AppNotifier.logWithScreen("Auth Controller", "✅ Login successful");
        },
      );
      return true;
    } catch (e) {
      _showError("Login error: $e");
      return false;
    }
  }

  /// الحصول على token صالح للـ Graph API
  Future<String?> getGraphToken() async {
    try {
      String? token = await oauth.graphOAuth.getAccessToken();

      if (token == null) {
        AppNotifier.logWithScreen("GraphDioClient", "Token expired, refreshing...");
        final loggedIn = await loginMicrosoftOnce();
        if (!loggedIn) return null;
        token = await oauth.graphOAuth.getAccessToken();
      }

      await secureStorage.saveData("GraphAccessToken", token!);
      AppNotifier.logWithScreen("GraphDioClient", "Graph AccessToken: $token");
      return token;
    } catch (e) {
      _showError("Graph token error: $e");
      return null;
    }
  }

  /// الحصول على token صالح للـ SharePoint
  Future<String?> getSharePointToken() async {
    try {
      String? token = await oauth.spOAuth.getAccessToken();

      if (token == null) {
        AppNotifier.logWithScreen("SPClient", "Token expired, refreshing...");
        final loggedIn = await loginMicrosoftOnce();
        if (!loggedIn) return null;
        token = await oauth.spOAuth.getAccessToken();
      }

      await secureStorage.saveData("SPAccessToken", token!);
      return token;
    } catch (e) {
      _showError("SharePoint token error: $e");
      return null;
    }
  }

  /// الحصول على token صالح لـ MySharePoint
  Future<String?> getMySharePointToken() async {
    try {
      String? token = await oauth.mySpOAuth.getAccessToken();

      if (token == null) {
        AppNotifier.logWithScreen("MySPClient", "Token expired, refreshing...");
        final loggedIn = await loginMicrosoftOnce();
        if (!loggedIn) return null;
        token = await oauth.mySpOAuth.getAccessToken();
      }

      await secureStorage.saveData("MySPAccessToken", token!);
      return token;
    } catch (e) {
      _showError("MySharePoint token error: $e");
      return null;
    }
  }

  /// تسجيل الخروج من كل OAuth وحذف البيانات المخزنة
  Future<void> logout() async {
    await oauth.graphOAuth.logout();
    await oauth.spOAuth.logout();
    await oauth.mySpOAuth.logout();
    await secureStorage.deleteData();
  }

  /// تسجيل الدخول بالـ biometrics
  Future<bool> loginWithBiometrics() async {
    final authenticated = await biometricAuth.authenticateWithBiometrics();
    return authenticated;
  }

  void _showError(String message) {
    AppNotifier.logWithScreen("Auth Controller", message);
    AppNotifier.snackBar(context, message, SnackBarType.error);
  }
}
