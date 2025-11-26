import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../utils/export_import.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  late final AuthController _authController;
  late String graphToken;
  late String spToken, mySpToken;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SecureStorageService().getData("GraphAccessToken").then((value) {
        AppNotifier.logWithScreen("LoginScreen", "✅ Graph Token: $value");
        graphToken = value;
      });
      await SecureStorageService().getData("SharedAccessToken").then((value) {
        AppNotifier.logWithScreen("LoginScreen", "✅ SharedPoint Token: $value");
        spToken = value;
      });
      await SecureStorageService().getData("MySharedAccessToken").then((value) {
        AppNotifier.logWithScreen(
            "LoginScreen", "✅ MySharedPoint Token: $value");
        mySpToken = value;
      });
    });
    _authController = AuthController(context: context);
  }

  Future<void> _onSignInPressed() async {
    setState(() => _isLoading = true);

    final graphToken = await SecureStorageService().getData("GraphAccessToken");
    final spToken = await SecureStorageService().getData("SPAccessToken");

    bool success = false;
    String type = "";

    if (graphToken.isNotEmpty && spToken.isNotEmpty && mySpToken.isNotEmpty) {
      type = "Biometric";
      success = await _authController.loginWithBiometrics();
      SecureStorageService().saveData("BiometricLogin", "$type $success");
      AppNotifier.logWithScreen(
          "LoginScreen", "✅ Biometric Login Success: $success");
    } else {
      type = "Microsoft";
      success = await loginAll();
      AppNotifier.logWithScreen(
          "LoginScreen", "✅ Microsoft Login Success: $success");
    }

    AppNotifier.logWithScreen("LoginScreen", "✅ $type Login Success: $success");

    if (success && mounted) {
      _navigateToHome();
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<bool> loginAll() async {
    try {
      final loginSuccess = await _authController.loginMicrosoftOnce();
      if (!loginSuccess) return false;

      final graphToken = await _authController.getGraphToken();
      if (graphToken == null) return false;
      await SecureStorageService()
          .saveData("TokenSavedAt", DateTime.now().toIso8601String());

      final spToken = await _authController.getSharePointToken();
      if (spToken == null) return false;
      await SecureStorageService()
          .saveData("SPTokenSavedAt", DateTime.now().toIso8601String());

      final mySpToken = await _authController.getMySharePointToken();
      if (mySpToken == null) return false;
      await SecureStorageService()
          .saveData("MySPTokenSavedAt", DateTime.now().toIso8601String());

      AppNotifier.logWithScreen(
          "LoginScreen", "✅ Graph token retrieved: $graphToken");
      AppNotifier.logWithScreen(
          "LoginScreen", "✅ SharePoint token retrieved: $spToken");
      AppNotifier.logWithScreen(
          "LoginScreen", "✅ MySharePoint token retrieved: $mySpToken");

      return true;
    } catch (e) {
      AppNotifier.logWithScreen("LoginScreen", "❌ loginAll error: $e");
      return false;
    }
  }

  void _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const LanguageSwitcher(),
              const Expanded(
                  child: LogoAndCarouselWidget(
                      assetPath: 'assets/images/alsanidi_logo.png')),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SignInButton(
                  text: local.signIn,
                  isLoading: _isLoading,
                  handleMicrosoftLogin: _onSignInPressed,
                  loginArrowIcon: context.loginArrowIcon,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
