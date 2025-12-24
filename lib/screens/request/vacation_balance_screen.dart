import 'package:company_portal/screens/request/widgets/balance_screen.dart';
import 'package:company_portal/screens/request/widgets/transactions_screen.dart';
import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class VacationBalanceScreen extends StatefulWidget {
  const VacationBalanceScreen({super.key});

  @override
  State<VacationBalanceScreen> createState() => _VacationBalanceScreenState();
}

class _VacationBalanceScreenState extends State<VacationBalanceScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final userId = context.read<UserInfoProvider>().userInfo?.id;
  //     if (userId != null) {
  //       context.read<VacationBalanceProvider>().getVacationTransactions(userId);
  //     }
  //   });
  // }

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
              headerSection(local.leavesBalance),
              const BalanceScreen(),
              headerSection(local.leavesTransactions),
              const TransactionsScreen()
            ],
          ),
        ),
      ),
    );
  }
}
