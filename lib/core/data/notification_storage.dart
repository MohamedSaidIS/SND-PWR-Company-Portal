import 'dart:convert';

import '../../../utils/export_import.dart';

class NotificationStorage {
  Future<void> saveNotification(AppNotification notification) async {
    final list = PreferenceManager().getStringList(Constants.notifications) ?? [];
    list.insert(0, jsonEncode(notification.toJson()));
    await PreferenceManager().setStringList(Constants.notifications, list);
  }

  Future<List<AppNotification>> getAllNotification() async {
    final list = PreferenceManager().getStringList(Constants.notifications) ?? [];

    return list.map((e) => AppNotification.fromJson(jsonDecode(e))).toList();
  }

 clearNotification() async{
    await PreferenceManager().remove(Constants.notifications);
  }
}
