import 'package:company_portal/screens/login/login_screen_new.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:company_portal/service/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'enums.dart';

class AppNotifier {

  static void logWithScreen(String screen, String message) {
    print("[$screen] $message");
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

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreenNew()),
                          (route) => false,
                    );
                  } catch (e) {
                    AppNotifier.logWithScreen("Logout Dialog", "Logout Failed: $e");
                  }
                },
              )
            ],
          )),
    );
  }

  static void loginAgain(BuildContext context) async {
    await SecureStorageService().deleteData();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreenNew()),
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
              color: theme.colorScheme.background.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/loading.json',
                  width: 150,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 15),
                Text(
                  message,
                  style: TextStyle(fontSize: 17, color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 15),
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
}
