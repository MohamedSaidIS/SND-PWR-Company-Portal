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

  Future<void> _onSignInPressed() async {
    setState(() => _isLoading = true);

    final oauth = Provider.of<AadOAuth>(context, listen: false);
    final oathController = AuthController(oauth: oauth, context: context);

    final success = await oathController.handleMicrosoftLogin();
    print("Success: $success");
    if(success && mounted){
      _navigateToHome();
    }
    if (mounted) setState(() => _isLoading = false);
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
          child: Stack(
            children: [
              LanguageSwitcher(
                localeProvider: localeProvider,
                currentLocale: currentLocale,
                onLanguageChanged: () => changeLanguage(localeProvider, currentLocale)
              ),
              const LogoAndCarouselWidget(assetPath: 'assets/images/alsanidi_logo.png'),
              SignInButton(
                text: local.signIn,
                isLoading: _isLoading,
                handleMicrosoftLogin: _onSignInPressed,
                loginArrowIcon: context.loginArrowIcon,
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
