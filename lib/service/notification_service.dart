import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  String? _currentUserId;
  static int _notificationId = 0;

  Future<void> init(String userId) async {
    AppLogger.info("Notification Service", 'Initialization: $_initialized | $_currentUserId');

    if (!_initialized) {
      _initialized = true;
      await _requestPermissions();
      await _initLocalNotification();
      await _subscribeTopics();
      _listen();
    }

    _currentUserId = userId;
    AppLogger.info("Notification Service", 'Initialization: $_initialized | $_currentUserId');

    await _registerTokenWithRetry(userId);
  }

  Future<void> _requestPermissions() async {
    AppLogger.info("Notification Service","RequestPermission");
    if(Platform.isIOS){
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      AppLogger.info(
        "Notification Service",
        "Permission status: ${settings.authorizationStatus}",
      );

      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      String? apnsToken;
      while (apnsToken == null) {
        AppLogger.info("Notification Service", 'APNS Token b: $apnsToken');
        apnsToken = await _fcm.getAPNSToken();
        await Future.delayed(const Duration(milliseconds: 300));
      }
      AppLogger.info("Notification Service", 'APNS Token: $apnsToken');
    }
  }

  Future<void> _initLocalNotification() async {
    AppLogger.info("Notification Service","LocalNotification");
    const androidChannel = AndroidNotificationChannel(
      'default_channel', // نفس id المستخدم في NotificationDetails
      'General',
      description: 'General notifications',
      importance: Importance.max,
    );

    await _local
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    const settings = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: DarwinInitializationSettings());

    await _local.initialize(
        settings,
        onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

  }

  Future<void> _subscribeTopics() async {
    AppLogger.info("Notification Service","SubscribeTopics");
    await _fcm.subscribeToTopic('allUsers');
    if (_currentUserId != null) {
      await _fcm.subscribeToTopic('user_$_currentUserId');
    }
  }

  Future<void> _registerTokenWithRetry(String userId) async {
    AppLogger.info("Notification Service", "UserId: $userId");
      try {
        final fcmToken = await getFCMTokenSafe();
        AppLogger.info("Notification Service", "Token: $fcmToken");
        if (fcmToken != null) {
          await _sendTokenToServer(userId, fcmToken);
          return;
        } else {
          AppLogger.error("Notification Service", 'FCM Token is null');
        }
      }catch(e){
        AppLogger.error("Notification Service", "❌ Failed to get FCM token  $e");
      }

  }

  Future<String?> getFCMTokenSafe() async {
    if (Platform.isIOS) {
      String? apnsToken;
      while (apnsToken == null) {
        apnsToken = await _fcm.getAPNSToken();
        await Future.delayed(const Duration(milliseconds: 300));
      }
      AppLogger.info("Notification Service", "APNS ready $apnsToken");
    }
    return await _fcm.getToken();
  }

  Future<void> _sendTokenToServer(String userId, String token) async {
    final platform = Platform.isAndroid
        ? 'android'
        : Platform.isIOS
        ? 'ios'
        : 'web'; // optional

    try {
      print("Platform $platform");
      await Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {"Content-Type": "application/json"},
      )).post(
        'https://geophagous-nontrailing-moon.ngrok-free.dev/save-token',
        options: Options(
          headers: {
            "Content-Type": "application/json"
          },
        ),
        data: {'userId': userId, 'token': token, 'platform': platform},
      );

      AppLogger.info("Notification Service", "✅ Token sent");
    } catch (e) {
      AppLogger.error("Notification Service", "❌ Token send failed: $e");
    }
  }


  void _onLocalNotificationTap(NotificationResponse response) {
    AppLogger.info("Notification Service", "🔔 Local notification tapped");

    if (response.payload == null) return;

    final data = Map<String, dynamic>.from(jsonDecode(response.payload!));

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

    _fcm.onTokenRefresh.listen((token) {
      if (_currentUserId != null) {
        _sendTokenToServer(_currentUserId!, token);
      }
    });
  }

  void _onForeground(RemoteMessage message) async {
    AppLogger.info("Notification Service", '🔔 Notification opened');
    final notification = message.notification;
    if (notification == null) return;
    AppLogger.info("Notification Service", '🔔 Notification opened');
    AppLogger.info("Notification Service", 'DATA: ${message.data}');

    await Future.delayed(const Duration(milliseconds: 100));

    if(Platform.isAndroid){
      _local.show(
      _notificationId++,
      notification.title,
      notification.body,
      const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'General',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            autoCancel: true,
            sound: RawResourceAndroidNotificationSound('notification_sound'),
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          )
      ),
      payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
    );
    }

    _saveNotification(message);

  }

  void _onOpen(RemoteMessage message) {
    AppLogger.info("Notification Service", '🔔 Notification opened');
    AppLogger.info("Notification Service", 'DATA: ${message.data}');

    _saveNotification(message);
    _handleNavigation(message.data);
  }

  void _saveNotification(RemoteMessage message) {
    final notification = message.notification;

    final appNotification = AppNotification(
      id: message.messageId ?? DateTime.now().toIso8601String(),
      title: notification?.title,
      body: notification?.body,
      data: message.data,
      date: DateTime.now(),
    );

    AppNavigator.key.currentContext
        ?.read<NotificationProvider>()
        .add(appNotification);
  }

  void _handleNavigation(Map<String, dynamic> data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final type = data['type'];

      if (type == 'notification') {
        AppNavigator.state?.pushNamed('/notification');
      }
    });
  }








}

