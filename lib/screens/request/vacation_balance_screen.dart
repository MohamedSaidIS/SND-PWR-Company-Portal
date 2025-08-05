import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

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
            local.vacationBalanceRequest,
            style: theme.textTheme.headlineLarge,
          ),
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
