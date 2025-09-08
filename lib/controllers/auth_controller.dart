import 'package:aad_oauth/aad_oauth.dart';
import 'package:flutter/cupertino.dart';
import '../service/sharedpref_service.dart';
import '../utils/app_notifier.dart';
import '../utils/biomertic_auth.dart';
import '../utils/enums.dart';
import '../utils/secure_storage_service.dart';

class AuthController {
  final AadOAuth oauth;
  final BuildContext context;
  final SecureStorageService secureStorage = SecureStorageService();
  final BiometricAuth biometricAuth = BiometricAuth();

  AuthController({
    required this.oauth,
    required this.context,
  });

  Future<bool> handleMicrosoftLogin() async {
    try {
      await _clearPreviousSession();
      return await _performMicrosoftLogin();

    } catch (e) {
      _showError(e.toString());
      return false;
    }
  }

  Future<void> _clearPreviousSession() async {
    await secureStorage.deleteData();
  }

  Future<bool> _performMicrosoftLogin() async {
    final result = await oauth.login();

    return await result.fold(
          (failure) {
        _showError(failure.message);
        return Future.value(false);
      },
          (success) async {
        final token = await _getAccessToken();
        if (token == null) {
          _showError('Failed to retrieve access token');
          return false;
        }
        return true;
      },
    );
  }

  void _showError(String message) {
    AppNotifier.snackBar(context, message, SnackBarType.error);
  }

  Future<String?> _getAccessToken() async {
    try{
      final accessToken = await oauth.getAccessToken();
      if (accessToken != null) {
        await secureStorage.saveData("AccessToken", accessToken);
        await secureStorage.saveData("TokenSavedAt", DateTime.now().toIso8601String());
        return accessToken;
      }
    } catch (e) {
      _showError("Error getting access token: $e");
    }
    return null;
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
}
