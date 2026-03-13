import 'package:flutter/material.dart';
import '../utils/export_import.dart';

class LocaleProvider extends ChangeNotifier{

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) async{
    _locale = locale;
    await PreferenceManager().setString(Constants.languageCode, locale.languageCode);
    AppLogger.info("Selected Locale: ",locale.languageCode);

    notifyListeners();
  }

  Future<void> loadSavedLocale() async {
    final langCode = PreferenceManager().getString(Constants.languageCode);
    AppLogger.info("Loaded Locale: ",locale.languageCode);

    if (langCode != null) {
      _locale = Locale(langCode);
      notifyListeners();
    }
  }

}