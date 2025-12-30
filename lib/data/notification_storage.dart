import 'dart:convert';

import 'package:company_portal/models/local/app_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationStorage {
  static const _key = 'notifications';

  Future<void> save(AppNotification notification) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    list.insert(0, jsonEncode(notification.toJson()));
    await prefs.setStringList(_key, list);
  }

  Future<List<AppNotification>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    return list.map((e) => AppNotification.fromJson(jsonDecode(e))).toList();
  }

  Future<void> clear() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
