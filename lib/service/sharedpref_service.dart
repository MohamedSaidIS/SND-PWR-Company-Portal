import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {

// Write Data
   Future<void> saveUserData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    print("$key $value");
    await prefs.setString(key, value);
  }

// Read Data
   Future<String?> getUserData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

// Remove Specific Data
  Future<void> removeData(String key) async {
    final  prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);

  }

// Clear All Data
  Future<void> clearData() async {
    final  prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}