import 'package:flutter/material.dart';
import '../../../utils/export_import.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.notifications,
         backBtn: true,
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
