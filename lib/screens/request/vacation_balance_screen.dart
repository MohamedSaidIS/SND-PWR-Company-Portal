import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../common/custom_app_bar.dart';

class VacationBalanceScreen extends StatefulWidget {
  const VacationBalanceScreen({super.key});

  @override
  State<VacationBalanceScreen> createState() => _VacationBalanceScreenState();
}

class _VacationBalanceScreenState extends State<VacationBalanceScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: CustomAppBar(
          title: local.vacationBalanceRequestLine,
          backBtn: true,
        ),
        body: Center(
            child: Text(
          "Vacation Balance Screen",
          style: TextStyle(color: theme.colorScheme.primary),
        )),
      ),
    );
  }
}
