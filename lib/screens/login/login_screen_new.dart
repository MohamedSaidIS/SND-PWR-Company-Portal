import 'dart:async';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:company_portal/controllers/auth_controller.dart';
import 'package:company_portal/providers/locale_provider.dart';
import 'package:company_portal/screens/login/widgets/language_switcher.dart';
import 'package:company_portal/screens/login/widgets/logo_carousel_widget.dart';
import 'package:company_portal/screens/login/widgets/sign_in_button.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late final graphToken;

  late final spToken;

  // late final BiometricAuth _biometricAuth;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SecureStorageService().getData("GraphAccessToken").then((value) {
        print("✅ Graph Token: $value");
        graphToken = value;
      });
      await SecureStorageService().getData("SharedAccessToken").then((value) {
        print("SharedPoint Token: $value");
        spToken = value;
      });
    });
    _authController = AuthController(context: context);
    // _biometricAuth = BiometricAuth();

    // _checkForBiometricLogin();
  }

  // Future<void> _checkForBiometricLogin() async {
  //   print("Checking for biometric login");
  //   final token = await SecureStorageService().getData("AccessToken");
  //   if (token != null && token.isNotEmpty) {
  //     final bioSuccess = await _biometricAuth.authenticateWithBiometrics();
  //     print("Checking for biometric login");
  //     if(bioSuccess && mounted){
  //       _navigateToHome();
  //     }
  //   }
  // }

  Future<void> _onSignInPressed() async {
    setState(() => _isLoading = true);

    final graphToken = await SecureStorageService().getData("GraphAccessToken");
    final spToken = await SecureStorageService().getData("SharedAccessToken");

    bool success = false;
    String type = "";

    if (graphToken.isNotEmpty && spToken.isNotEmpty) {
      type = "Biometric";
      success = await _authController.loginWithBiometrics();
      SecureStorageService().saveData("BiometricLogin", "$type $success");
      print("✅ Biometric Login Success: $success");
    } else {
      type = "Microsoft";
      success = await loginAll();
      print("✅ Microsoft Login Success: $success");
    }
    print("✅ $type Login Success: $success");

    if (success && mounted) {
      _navigateToHome();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<bool> loginAll() async {
    final bool graphToken, spToken;

    graphToken = await _authController.getGraphToken();
    if (graphToken) {
      print("✅ Graph token: $graphToken");

      spToken = await _authController.getSharePointToken();
      print("✅ SharePoint token: $spToken");

      if (spToken == false) return false;
    } else {
      return false;
    }
    return graphToken && spToken ? true : false;
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
        backgroundColor: theme.colorScheme.background,
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
