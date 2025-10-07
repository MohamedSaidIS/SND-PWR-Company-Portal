import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../common/custom_app_bar.dart';

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

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.permissionRequestLine,
          backBtn: true,
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
