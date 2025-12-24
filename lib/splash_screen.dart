import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key,});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isImagePrecached = false;

  @override
  void initState() {
    super.initState();

    _initFCM();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
          const LoginScreen()
           //  LoginScreen(),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isImagePrecached) {
      precacheImage(
        const AssetImage("assets/images/logo_launcher.png"),
        context,
      );
      _isImagePrecached = true;
    }
  }

  Future<void> _initFCM() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    AppNotifier.logWithScreen("Splash Screen", "🔔 Permission: ${settings.authorizationStatus}");

    String? token = await FirebaseMessaging.instance.getToken();
    AppNotifier.logWithScreen("Splash Screen", "📱 FCM Token: $token");
    // TODO: ابعتيه للـ backend (Azure Function / DB)

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppNotifier.logWithScreen("Splash Screen", "📩 Foreground: ${message.notification?.title}");
      AppNotifier.logWithScreen("Splash Screen", "Body: ${message.notification?.body}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppNotifier.logWithScreen("Splash Screen", "👉 Opened from notification: ${message.data}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f768e),
      body: Center(
        child: RepaintBoundary(child: Image.asset("assets/images/logo_launcher.png")),
      ),
    );
  }
}
