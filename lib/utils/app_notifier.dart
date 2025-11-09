import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../utils/export_import.dart';
import '../main.dart';

class AppNotifier {

  static void logWithScreen(String screen, String message) {
    debugPrint("[$screen] $message");
  }

  static void showLogoutDialog(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    showDialog(
      context: context,
      builder: (_) => FocusScope(
          child: AlertDialog(
            title: Text(local.logout),
            content: Text(local.areYouSureYouWantToLogout),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  local.cancel,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              TextButton(
                child: Text(
                  local.logout,
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                onPressed: () async {
                  try {
                    await SecureStorageService().deleteData();

                    // final logoutUrl =
                    //     "https://login.microsoftonline.com/${EnvConfig.msTenantId}/oauth2/v2.0/logout"
                    //     "?post_logout_redirect_uri=${Uri.encodeComponent(EnvConfig.msRedirectUri)}";
                    //
                    // final launched = await launchUrl(Uri.parse(logoutUrl));
                    //
                    // if (!launched) {
                    //   debugPrint("⚠️ Logout URL لم يُفتح بنجاح");
                    // }
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      createLogoutRoute(const LoginScreen()),
                          (_) => false,
                    );
                  } catch (e) {
                    AppNotifier.logWithScreen("Logout Dialog", "Logout Failed: $e");
                  }
                },
              )
            ],
          ),
      ),
    );
  }

  static void sessionExpiredDialog() {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;

    final theme = ctx.theme;
    final local = ctx.local;

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (ctx) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    local.sessionExpired,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      local.pleaseLoginAgain,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    color: Colors.black12,
                  ),
                  TextButton(
                    onPressed: () async {
                      await SecureStorageService().deleteData();
                      navigatorKey.currentState?.pushAndRemoveUntil(
                          AppNotifier.createLogoutRoute(const LoginScreen()),
                          (route) => false,
                      );
                    },
                    child: Text(
                      local.ok,
                      style: TextStyle(
                        fontSize: 18,
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Route createLogoutRoute(Widget screen) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOut),
        );
        final slide = Tween(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: child,
          ),
        );
      },
    );
  }


  static void loginAgain(BuildContext context) async {
    await SecureStorageService().deleteData();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  static void snackBar(BuildContext context, String text, SnackBarType type) {
    Color iconColor, textColor;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        iconColor = const Color(0xFF4CAF50);
        textColor = const Color(0xFF2E7D32);
        icon = Icons.check_circle;
        break;
      case SnackBarType.error:
        iconColor = const Color(0xFFF44336);
        textColor = const Color(0xFFB71C1C);
        icon = Icons.error;
        break;
      case SnackBarType.warning:
        iconColor = const Color(0xFFFF9800);
        textColor = const Color(0xFFF57C00);
        icon = Icons.warning;
        break;
      case SnackBarType.info:
        iconColor = const Color(0xFF2196F3);
        textColor = const Color(0xFF1976D2);
        icon = Icons.info;
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
    ));
  }

  static void showLoadingDialog(BuildContext context, String message, ThemeData theme) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha:0.7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/loading.json',
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: TextStyle(fontSize: 17, color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }


  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  static bool _isLoading = false;

  static void showLoading(BuildContext? context, String message) {
    if (_isLoading || context == null) return;
    _isLoading = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void hideLoading(BuildContext? context) {
    if (!_isLoading || context == null) return;
    _isLoading = false;
    Navigator.of(context, rootNavigator: true).pop();
  }

  static Widget loadingWidget(ThemeData theme) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.5),
        strokeWidth: 2.5,
        color: theme.colorScheme.secondary,
      ),
    );
  }

}
