import 'package:company_portal/screens/request/vacation_balance/components/balance_screen.dart';
import 'package:company_portal/screens/request/vacation_balance/components/transactions_screen.dart';
import 'package:company_portal/screens/request/vacation_balance/components/vacation_balance_section_header.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/export_import.dart';

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
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.vacationBalanceRequestLine,
          backBtn: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: CustomScrollView(
            slivers: [
              VacationBalanceSectionHeader(title:local.leavesBalance),
              const BalanceScreen(),
              VacationBalanceSectionHeader(title: local.leavesTransactions),
              const TransactionsScreen()
            ],
          ),
        ),
      ),
    );
  }
}
