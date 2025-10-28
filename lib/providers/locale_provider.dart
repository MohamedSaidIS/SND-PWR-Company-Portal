import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_notifier.dart';

class LocaleProvider extends ChangeNotifier{

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) async{
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    AppNotifier.logWithScreen("Selected Locale: ",locale.languageCode);

    notifyListeners();
  }

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language_code');
    AppNotifier.logWithScreen("Loaded Locale: ",locale.languageCode);

    if (langCode != null) {
      _locale = Locale(langCode);
      notifyListeners();
    }
  }

}