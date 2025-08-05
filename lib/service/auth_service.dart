import 'package:aad_oauth/aad_oauth.dart';
import 'package:company_portal/service/sharedpref_service.dart';

class AuthService {
  static Future<String?> getAccessToken(
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
      print("Error getting access token: $e");
    }
    return null;
  }

}
