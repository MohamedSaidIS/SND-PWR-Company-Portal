import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, /*required this.navigatorKey*/});

  //final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isImagePrecached = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
             LoginScreen(/*navigatorKey: widget.navigatorKey*/),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f768e),
      body: Center(
        child: Image.asset("assets/images/logo_launcher.png"),
      ),
    );
  }
}
