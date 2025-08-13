import 'dart:async';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:company_portal/data/login_data.dart';
import 'package:company_portal/providers/locale_provider.dart';
import 'package:company_portal/screens/login/login_screen.dart';
import 'package:company_portal/service/auth_service.dart';
import 'package:company_portal/service/sharedpref_service.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/enums.dart';
import '../home/home_screen.dart';

class LoginScreenNew extends StatefulWidget {
  const LoginScreenNew({super.key,});

  @override
  State<StatefulWidget> createState() => _LoginScreenNewState();
}

class _LoginScreenNewState extends State<LoginScreenNew> {
  final ScrollController _scrollController = ScrollController();
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  int newIndex = 0;
  bool _logoAtTop = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 0 && !_logoAtTop) {
        setState(() {
          _logoAtTop = true;
        });
      }
    });
  }

  void changeLanguage(LocaleProvider localeProvider, String currentLocale, String languageCode){
    currentLocale == 'en' ? languageCode = 'ar' : languageCode = 'en';
    localeProvider.setLocale(Locale(languageCode));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreenNew(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final localeProvider = context.localeProvider;
    final currentLocale = context.currentLocale();
    final loginArrowIcon = context.loginArrowIcon;
    final positionRight = context.positionRight;
    final positionLeft = context.positionLeft;
    String languageCode = currentLocale;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: positionRight,
                  right: positionLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => changeLanguage(localeProvider, currentLocale, languageCode),
                            child: const Icon(Icons.language, color: Color(0xFF1B818E) , size: 30,)),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Center(
                        child: Text(languageCode.toUpperCase() == "AR" ? local.aR :local.eN,
                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 18),),
                      ),
                    )
                      ],
                    ),
                  )),
              Positioned(
                top: 25,
                right: 35,
                left: 35,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Image.asset(
                    'assets/images/alsanidi_logo.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:140.0, bottom: 90.0),
                child: Column(
                  children: [
                    CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.55 ,
                        autoPlay: true,
                        aspectRatio: 3.0,
                        enlargeCenterPage: true,
                        disableCenter: true,
                        onPageChanged: (index, reason){
                          setState(() {
                            _current = index;
                          });
                        }
                       ),
                      items: getItems(local, theme, context),

                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(getItems(local, theme, context).length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                          height: 8,
                          width: _current == index ? 25 : 8,
                          decoration: BoxDecoration(
                            color: _current == index ? const Color(0xFF1B818E) : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: positionRight,
                left: positionLeft,
                child: Container(
                  height: 80,
                  color: theme.colorScheme.background,
                  padding: const EdgeInsets.all(16),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _signInButton(local.signIn, _isLoading,
                          handleMicrosoftLogin, theme, loginArrowIcon),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleMicrosoftLogin() async {
    setState(() => _isLoading = true);
    final oauth = Provider.of<AadOAuth>(context, listen: false);
    final sharedPrefHelper = SharedPrefsHelper();
    sharedPrefHelper.clearData();
    try {
      final result = await oauth.login();
      result.fold(
          (failure) => AppNotifier.snackBar(context, failure.message, SnackBarType.error),
          (success) async{
            final token = await AuthService.getAccessToken(oauth, sharedPrefHelper);
            if(token != null && mounted){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            }else{
              AppNotifier.snackBar(context, 'Failed to retrieve access token', SnackBarType.error);
            }
          } ,
      );
    } on PlatformException catch (e) {
      AppNotifier.snackBar(context, e.message!, SnackBarType.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

Widget _signInButton(
    String text,
    bool isLoading,
    Future<void> Function() handleMicrosoftLogin,
    ThemeData theme,
    IconData loginArrowIcon) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1B818E),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 4,
      shadowColor: Colors.black38,
    ),
    onPressed: isLoading ? null : handleMicrosoftLogin,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          text,
          style: theme.textTheme.labelSmall,
        ),
        const SizedBox(width: 8),
        Icon(
          loginArrowIcon,
          color: theme.colorScheme.background,
        ),
      ],
    ),
  );
}


