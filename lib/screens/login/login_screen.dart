import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
  // late final MsalAuthController authController;
  late String graphToken;
  late String spToken, mySpToken;
  final SecureStorageService secureStorage = SecureStorageService();

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

    // final oauth = context.read<AuthConfigController>();
    // authController = MsalAuthController(oauth: oauth, context: context);
  }

  Future<void> _onSignInPressed() async {
    setState(() => _isLoading = true);

    final graphToken = await SecureStorageService().getData("GraphAccessToken");
    final spToken = await SecureStorageService().getData("SPAccessToken");

    bool success = false;
    String type = "";

    if (graphToken.isNotEmpty && spToken.isEmpty && mySpToken.isEmpty) {
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
      // _navigateToWeb();
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

  // Future<void> _onSignInPressed() async {
  //   setState(() => _isLoading = true);
  //
  //   final graphToken = await secureStorage.getData("GraphAccessToken");
  //   final spToken = await secureStorage.getData("SPAccessToken");
  //   final mySpToken = await secureStorage.getData("MySPAccessToken");
  //
  //   bool success = false;
  //   String type = "";
  //
  //   if (graphToken.isNotEmpty && spToken.isEmpty && mySpToken.isEmpty) {
  //     type = "Biometric";
  //     success = await authController.loginWithBiometrics();
  //     await secureStorage.saveData("BiometricLogin", "$type $success");
  //     AppNotifier.logWithScreen(
  //         "AuthController", "✅ Biometric Login Success: $success");
  //   } else {
  //     type = "Microsoft";
  //     success = await loginAll();
  //     AppNotifier.logWithScreen(
  //         "AuthController", "✅ Microsoft Login Success: $success");
  //   }
  //
  //   AppNotifier.logWithScreen(
  //       "AuthController", "✅ $type Login Success: $success");
  //
  //   if (success && mounted) {
  //     _navigateToHome();
  //   }
  //
  //   setState(() => _isLoading = false);
  // }
  //
  // Future<bool> loginAll() async {
  //   try {
  //     final loginSuccess = await authController.loginMicrosoftOnce();
  //     if (!loginSuccess) return false;
  //
  //     final graphToken = await authController.getGraphToken();
  //     if (graphToken == null) return false;
  //     await secureStorage.saveData("GraphAccessToken", graphToken);
  //     await secureStorage.saveData("TokenSavedAt", DateTime.now().toIso8601String());
  //
  //
  //     final spToken = await authController.getSharePointToken();
  //     if (spToken == null) return false;
  //     await secureStorage.saveData("SPAccessToken", spToken);
  //     await secureStorage.saveData("SPTokenSavedAt", DateTime.now().toIso8601String());
  //
  //
  //     final mySpToken = await authController.getMySharePointToken();
  //     if (mySpToken == null) return false;
  //     await secureStorage.saveData("MySPAccessToken", mySpToken);
  //     await secureStorage.saveData("MySPTokenSavedAt", DateTime.now().toIso8601String());
  //
  //     AppNotifier.logWithScreen(
  //         "AuthController", "✅ Graph token retrieved: $graphToken");
  //     AppNotifier.logWithScreen(
  //         "AuthController", "✅ SharePoint token retrieved: $spToken");
  //     AppNotifier.logWithScreen(
  //         "AuthController", "✅ MySharePoint token retrieved: $mySpToken");
  //
  //     return true;
  //   } catch (e) {
  //     AppNotifier.logWithScreen("AuthController", "❌ loginAll error: $e");
  //     return false;
  //   }
  // }

  void _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void _navigateToWeb() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse("https://alsanidi.sharepoint.com")),
        ),
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
              const Expanded(child: LogoAndCarouselWidget(assetPath: 'assets/images/alsanidi_logo.png')),
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
