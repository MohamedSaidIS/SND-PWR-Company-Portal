import 'package:company_portal/data/notification_storage.dart';
import 'package:company_portal/models/local/app_notification.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider extends ChangeNotifier{
  final _storage = NotificationStorage();

  List<AppNotification> _notifications = [];
  List<AppNotification> _filteredNotifications = [];

  List<AppNotification> get notifications => _notifications;
  List<AppNotification> get filteredNotifications => _filteredNotifications;

  String selectedFilter = 'All';

  void applyFilter(String type) {
    selectedFilter = type;

    if (type == 'All') {
      _filteredNotifications = List.from(_notifications);
    } else {
      _filteredNotifications = _notifications
          .where((e) => e.data['notificationType'] == type)
          .toList();
    }

    notifyListeners(); // 🔥 مهم جدًا
  }



  int get unreadCount => _notifications.where((e) => !e.isRead).length;

  Future<void> load() async{
    _notifications = await _storage.getAll();
    notifyListeners();
  }

  Future<void> add(AppNotification notification)async{
    _notifications.insert(0, notification);
    await _storage.save(notification);
    notifyListeners();
  }

  void markAsRead(String id){
    final index = _notifications.indexWhere((e) => e.id == id);
    if(index != -1){
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  Future<void> clearAll()async{
    _notifications.clear();
    await _storage.clear();
    notifyListeners();
  }
}