import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../common/custom_app_bar.dart';

class AttendLeaveScreen extends StatefulWidget {
  const AttendLeaveScreen({super.key});

  @override
  State<AttendLeaveScreen> createState() => _AttendLeaveScreenState();
}

class _AttendLeaveScreenState extends State<AttendLeaveScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: CustomAppBar(
          title: local.attendLeaveRequest,
          backBtn: true,
        ),
        body: Center(
            child: Text(
          "Attend/Leave Screen",
          style: TextStyle(color: theme.colorScheme.primary),
        )),
      ),
    );
  }
}
