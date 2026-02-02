import 'package:company_portal/data/notification_storage.dart';
import 'package:flutter/cupertino.dart';
import '../../../utils/export_import.dart';

class NotificationProvider extends ChangeNotifier{
  final _storage = NotificationStorage();

  final List<AppNotification> _notifications = [];
  List<AppNotification> _filteredNotifications = [];

  String selectedFilter = 'all';

  List<AppNotification> get notifications => _filteredNotifications;

  void _applyCurrentFilter() {
    if (selectedFilter == 'all') {
      _filteredNotifications = List.from(_notifications);
    } else {
      _filteredNotifications = _notifications
          .where((e) => e.data['notificationType'] == selectedFilter)
          .toList();
    }
  }

  void applyFilter(String type) {
    selectedFilter = type;
    _applyCurrentFilter();
    notifyListeners();
  }



  int get unreadCount => _notifications.where((e) => !e.isRead).length;

  Future<void> load() async{
    final stored = await _storage.getAll();

    for (final n in stored) {
      if (!_notifications.any((e) => e.id == n.id)) {
        _notifications.add(n);
      }
    }

    _applyCurrentFilter();
    notifyListeners();
  }

  Future<void> add(AppNotification notification)async{
    if (_notifications.any((e) => e.id == notification.id)) return;

    _notifications.insert(0, notification);
    await _storage.save(notification);
    _applyCurrentFilter();
    notifyListeners();
  }

  void markAsRead(String id){
    final index = _notifications.indexWhere((e) => e.id == id);
    if(index != -1){
      _notifications[index].isRead = true;
      _applyCurrentFilter();
      notifyListeners();
    }
  }

  Future<void> clearAll()async{
    _notifications.clear();
    _filteredNotifications.clear();
    await _storage.clear();
    notifyListeners();
  }

  void markAllAsRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    _applyCurrentFilter();
    notifyListeners();
  }
}