import 'dart:async';
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
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
        child: RepaintBoundary(child: Image.asset("assets/images/logo_launcher.png")),
      ),
    );
  }
}
