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
  late String graphToken, spToken, mySpToken;


  @override
  void initState() {
    super.initState();
    _authController = AuthController(context: context);
    _fetchTokens();
  }

  Future<void> _fetchTokens() async {
    try {
      graphToken = await SecureStorageService().getData("GraphAccessToken");
      spToken = await SecureStorageService().getData("SharedAccessToken");
      mySpToken = await SecureStorageService().getData("MySharedAccessToken");

      AppNotifier.logWithScreen("LoginScreen", "✅ Graph Token: $graphToken");
      AppNotifier.logWithScreen("LoginScreen", "✅ SharedPoint Token: $spToken");
      AppNotifier.logWithScreen("LoginScreen", "✅ MySharedPoint Token: $mySpToken");

      if (mounted) setState(() {});
    } catch (e) {
      AppNotifier.logWithScreen("LoginScreen", "❌ Error fetching tokens: $e");
    }
  }

  Future<void> _onSignInPressed() async {
    if(_isLoading) return;
    setState(() => _isLoading = true);

    await _fetchTokens();

    bool success = false;

    if (graphToken.isNotEmpty && spToken.isNotEmpty && mySpToken.isNotEmpty) {

      success = await _authController.loginWithBiometrics();
      AppNotifier.logWithScreen("LoginScreen","✅ Biometric Login Success: $success");
    } else {
      success = await loginAll();
      AppNotifier.logWithScreen("LoginScreen","✅ Microsoft Login Success: $success");
    }

    if (success && mounted) _navigateToHome();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<bool> loginAll() async {
    try {
      final loginSuccess = await _authController.loginMicrosoftOnce();
      if (!loginSuccess) return false;

      final gToken = await _authController.getGraphToken();
      final sToken = await _authController.getSharePointToken();
      final mySToken = await _authController.getMySharePointToken();

      if (gToken == null || sToken == null || mySToken == null) return false;

      graphToken = gToken;
      spToken = sToken;
      mySpToken = mySToken;

      await SecureStorageService().saveData("TokenSavedAt", DateTime.now().toIso8601String());
      await SecureStorageService().saveData("SPTokenSavedAt", DateTime.now().toIso8601String());
      await SecureStorageService().saveData("MySPTokenSavedAt", DateTime.now().toIso8601String());

      AppNotifier.logWithScreen("LoginScreen","✅ Graph token retrieved: $graphToken");
      AppNotifier.logWithScreen("LoginScreen","✅ SharePoint token retrieved: $spToken");
      AppNotifier.logWithScreen("LoginScreen","✅ MySharePoint token retrieved: $mySpToken");

      return true;
    } catch (e) {
      AppNotifier.logWithScreen("LoginScreen","❌ loginAll error: $e");
      return false;
    }
  }

  void _navigateToHome() {
    // AppNotifier.createLogoutRoute(const HomeScreen());
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
    final localeProvider = context.localeProvider;
    final currentLocale = context.currentLocale();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LanguageSwitcher(
                  localeProvider: localeProvider,
                  currentLocale: currentLocale,
                  onLanguageChanged: () =>
                      changeLanguage(localeProvider, currentLocale)),
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

  void changeLanguage(
      LocaleProvider localeProvider,
      String currentLocale,
      ) {
    final newLanguageCode = currentLocale == 'en' ? 'ar' : 'en';
    localeProvider.setLocale(Locale(newLanguageCode));
  }
}
