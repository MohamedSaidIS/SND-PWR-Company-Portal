import 'dart:convert';

import '../../../utils/export_import.dart';

class NotificationStorageService {
  Future<void> saveNotification(AppNotification notification) async {
    final list = PreferenceManager().getStringList(StorageKey.notifications) ?? [];
    list.insert(0, jsonEncode(notification.toJson()));
    await PreferenceManager().setStringList(StorageKey.notifications, list);
  }

  Future<List<AppNotification>> getAllNotification() async {
    final list = PreferenceManager().getStringList(StorageKey.notifications) ?? [];

    return list.map((e) => AppNotification.fromJson(jsonDecode(e))).toList();
  }

 clearNotification() async{
    await PreferenceManager().remove(StorageKey.notifications);
  }
 }
