import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final backIcon = context.backIcon;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: theme.colorScheme.background,
          title: Text(local.notifications, style: theme.textTheme.headlineLarge),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              backIcon,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        body: Center(
          child: Text(
            "Notification Screen",
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
