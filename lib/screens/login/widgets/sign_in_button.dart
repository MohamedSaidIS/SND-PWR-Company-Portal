import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final Future<void> Function() handleMicrosoftLogin;
  final IconData loginArrowIcon;

  const SignInButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.handleMicrosoftLogin,
    required this.loginArrowIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isArabic = context.isArabic();

    final double screenWidth = context.screenWidth;
    final isTablet = context.isTablet();

    final double fontSize = screenWidth * (isArabic ? 0.035 : 0.04);
    final double iconSize = isTablet ? 26 : 22;

    return isLoading
        ? const CircularProgressIndicator()
        : FloatingActionButton.extended(
            onPressed: isLoading ? null : handleMicrosoftLogin,
            backgroundColor: const Color(0xFF1B818E),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(0, 0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: theme.colorScheme.surface,
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Icon(
                  loginArrowIcon,
                  color: theme.colorScheme.surface,
                  size: iconSize,
                ),
              ],
            ),
          );
  }
}
