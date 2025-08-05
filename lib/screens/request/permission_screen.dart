import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
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
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              backIcon,
              color: theme.colorScheme.primary,
            ),
          ),
          title: Text(
            local.permissionRequest,
            style: theme.textTheme.headlineLarge,
          ),
        ),
        body: Center(
          child: Text(
            "Permission Screen",
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
