import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/local/app_notification.dart';
import '../providers/notification_provider.dart';
import '../utils/export_import.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  Map<String, dynamic>? _pendingNavigationData;

  /// init once
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    // iOS permission
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    AppLogger.info("Notification Service", 'Initialization: $_initialized');
    await _fcm.subscribeToTopic('allUsers');

    const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
      'default_channel', // نفس id المستخدم في NotificationDetails
      'General',
      description: 'General notifications',
      importance: Importance.max,
    );

    await _local
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Local notification init
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _local.initialize(settings, onDidReceiveNotificationResponse: _onLocalNotificationTap);

    _listen();
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    AppLogger.info(
        "Notification Service", "🔔 Local notification tapped");

    if (response.payload == null) return;

    final data =
    Map<String, dynamic>.from(jsonDecode(response.payload!));

    _handleNavigation(data);
  }


  void _listen() {
    /// Foreground
    FirebaseMessaging.onMessage.listen(_onForeground);

    /// When user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpen);

    /// Terminated state
    _fcm.getInitialMessage().then((message) {
      if (message != null) _onOpen(message);
    });
  }

  void _onForeground(RemoteMessage message) async{
    final notification = message.notification;
    if (notification == null) return;
    AppLogger.info("Notification Service", '🔔 Notification opened');
    AppLogger.info("Notification Service", 'DATA: ${message.data}');

    await Future.delayed(const Duration(milliseconds: 100));
    _pendingNavigationData = message.data;

    int notificationId = 0;

    _local.show(
      notificationId++,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails('default_channel', 'General',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            autoCancel: false,
            sound: RawResourceAndroidNotificationSound('notification_sound')),
      ),
      payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
    );

    final appNotification = AppNotification(
      id: message.messageId ?? DateTime.now().toString(),
      title: notification.title,
      body: notification.body,
      data: message.data,
      date: DateTime.now(),
    );
    AppNavigator.key.currentContext
        ?.read<NotificationProvider>()
        .add(appNotification);
    // _handleNavigation(message.data);
  }

  void _onOpen(RemoteMessage message) {
    AppLogger.info("Notification Service", '🔔 Notification opened');
    AppLogger.info("Notification Service", 'DATA: ${message.data}');

    final notification = message.notification;
    final appNotification = AppNotification(
      id: message.messageId ?? DateTime.now().toString(),
      title: notification?.title,
      body: notification?.body,
      data: message.data,
      date: DateTime.now(),
    );
    AppNavigator.key.currentContext
        ?.read<NotificationProvider>()
        .add(appNotification);
    // _notificationStreamController.add(message.data);
    _handleNavigation(message.data);
  }

  void _handleNavigation(Map<String, dynamic> data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final type = data['type'];

      if (type == 'notification') {
        AppNavigator.state?.pushNamed('/notification');
      }
    });
  }

  Future<void> registerUser(String userId) async {
    final token = await _fcm.getToken();
    AppLogger.info("Notification Service", '📱 Token: $token');

    if (token != null) {
      await sendTokenToServer(userId, token);
      await _fcm.subscribeToTopic('user_$userId');
    }
  }

  Future<void> sendTokenToServer(String userId, String token) async {
    final url = Uri.parse(
        'https://geophagous-nontrailing-moon.ngrok-free.dev/save-token');
    await http.post(url, body: {
      'userId': userId,
      'token': token,
    });
  }
}
