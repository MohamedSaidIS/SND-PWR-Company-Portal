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
    final positionRight = context.positionRight;
    final positionLeft = context.positionLeft;
    final double screenWidth = context.screenWidth;
    final double screenHeight = context.screenHeight;

    final double buttonHeight = screenHeight * 0.1; // 10% of screen height
    final double paddingValue = screenWidth * 0.04; // 4% of screen width

    return Positioned(
      bottom: 0,
      right: positionRight,
      left: positionLeft,
      child: Container(
        height: buttonHeight,
        color: theme.colorScheme.background,
        padding: EdgeInsets.all(paddingValue),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B818E),
            padding:
            EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.015,
            ),
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
              SizedBox(width: screenWidth * 0.02),
              Icon(
                loginArrowIcon,
                color: theme.colorScheme.background,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
