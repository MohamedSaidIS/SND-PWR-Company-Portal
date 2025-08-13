import 'package:aad_oauth/aad_oauth.dart';
import 'package:company_portal/service/auth_service.dart';
import 'package:company_portal/service/sharedpref_service.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/enums.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key,});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ScrollController _scrollController = ScrollController();
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

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final loginArrowIcon = context.loginArrowIcon;
    final positionRight = context.positionRight;
    final positionLeft = context.positionLeft;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 150, bottom: 80),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle(local.sectionTitleOne, theme),
                      sectionText(local.sectionTextOne, theme),
                      sectionTitle(local.sectionTitleTwo, theme),
                      sectionText(local.sectionTextTwo, theme),
                      sectionTitle(local.sectionTitleThree, theme),
                      sectionText(local.sectionTextThree, theme),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Image.asset(
                    'assets/images/alsanidi_logo.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Fixed bottom button
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

Widget sectionTitle(String title, ThemeData theme) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(
      title,
      style: theme.textTheme.titleLarge,
    ),
  );
}

Widget sectionText(String text, ThemeData theme) {
  return Text(
    text,
    style: theme.textTheme.bodyLarge,
  );
}
