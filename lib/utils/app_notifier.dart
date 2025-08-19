import 'package:aad_oauth/aad_oauth.dart';
import 'package:company_portal/screens/login/login_screen_new.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'enums.dart';

class AppNotifier {
  static void printFunction(String text, dynamic value) {
    print("$text: $value");
  }

  static void showLogoutDialog(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final oauth = Provider.of<AadOAuth>(context, listen: false);

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
              Navigator.pop(context);
              await oauth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreenNew(),
                ),
              );
            },
          )
        ],
      )),
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
}
