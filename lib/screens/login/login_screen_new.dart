import 'dart:async';
import 'package:company_portal/controllers/auth_controller.dart';
import 'package:company_portal/providers/locale_provider.dart';
import 'package:company_portal/screens/login/widgets/language_switcher.dart';
import 'package:company_portal/screens/login/widgets/logo_carousel_widget.dart';
import 'package:company_portal/screens/login/widgets/sign_in_button.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import '../../service/secure_storage_service.dart';
import '../home/home_screen.dart';

class LoginScreenNew extends StatefulWidget {
  const LoginScreenNew({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _LoginScreenNewState();
}

class _LoginScreenNewState extends State<LoginScreenNew> {
  bool _isLoading = false;
  late final AuthController _authController;
  late String graphToken;
  late String spToken;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SecureStorageService().getData("GraphAccessToken").then((value) {
        AppNotifier.logWithScreen("LoginScreen", "✅ Graph Token: $value");
        graphToken = value;
      });
      await SecureStorageService().getData("SharedAccessToken").then((value) {
        AppNotifier.logWithScreen("LoginScreen","✅ SharedPoint Token: $value");
        spToken = value;
      });
      await SecureStorageService().getData("MySharedAccessToken").then((value) {
        AppNotifier.logWithScreen("LoginScreen","✅ MySharedPoint Token: $value");
        spToken = value;
      });
    });
    _authController = AuthController(context: context);
  }

  Future<void> _onSignInPressed() async {
    setState(() => _isLoading = true);

    final graphToken = await SecureStorageService().getData("GraphAccessToken");
    final spToken = await SecureStorageService().getData("SharePointAccessToken");

    bool success = false;
    String type = "";

    if (graphToken.isNotEmpty && spToken.isNotEmpty) {

      type = "Biometric";
      success = await _authController.loginWithBiometrics();
      SecureStorageService().saveData("BiometricLogin", "$type $success");
      AppNotifier.logWithScreen("LoginScreen","✅ Biometric Login Success: $success");
    } else {
      type = "Microsoft";
      success = await loginAll();
      AppNotifier.logWithScreen("LoginScreen","✅ Microsoft Login Success: $success");
    }

    AppNotifier.logWithScreen("LoginScreen","✅ $type Login Success: $success");

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

      final spToken = await _authController.getSharePointToken();
      if (spToken == null) return false;


      final mySpToken = await _authController.getMySharePointToken();
      if (mySpToken == null) return false;

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
                padding: const EdgeInsets.all(8.0),
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
