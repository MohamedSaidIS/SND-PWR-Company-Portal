import 'package:aad_oauth/aad_oauth.dart';
import 'package:flutter/cupertino.dart';
import '../service/sharedpref_service.dart';
import '../utils/app_notifier.dart';
import '../utils/enums.dart';

class AuthController {
  final AadOAuth oauth;
  final BuildContext context;

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
    final sharedPrefHelper = SharedPrefsHelper();
    sharedPrefHelper.clearData();
  }

  Future<bool> _performMicrosoftLogin() async {
    final result = await oauth.login();

    return await result.fold(
          (failure) {
        _showError(failure.message);
        return Future.value(false);
      },
          (success) async {
        final token = await _getAccessToken(
          oauth,
          SharedPrefsHelper(),
        );
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

  Future<String?> _getAccessToken(
      AadOAuth oauth,
      SharedPrefsHelper sharedPrefHelper,
      ) async {
    try{
      final accessToken = await oauth.getAccessToken();
      if (accessToken != null) {
        await sharedPrefHelper.saveUserData("AccessToken", accessToken);
        await sharedPrefHelper.saveUserData("TokenSavedAt", DateTime.now().toIso8601String());
        return accessToken;
      }
    } catch (e) {
      _showError("Error getting access token: $e");
    }
    return null;
  }
}
