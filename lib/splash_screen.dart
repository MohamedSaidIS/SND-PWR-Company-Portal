import 'dart:async';
import 'package:company_portal/screens/login/login_screen_new.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key,});

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
          const LoginScreenNew()
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
