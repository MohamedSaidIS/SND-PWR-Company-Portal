import 'package:company_portal/providers/user_info_provider.dart';
import 'package:company_portal/providers/vacation_balance_provider.dart';
import 'package:company_portal/screens/request/widgets/vacation_balance_sections.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/custom_app_bar.dart';

class VacationBalanceScreen extends StatefulWidget {
  const VacationBalanceScreen({super.key});

  @override
  State<VacationBalanceScreen> createState() => _VacationBalanceScreenState();
}

class _VacationBalanceScreenState extends State<VacationBalanceScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<UserInfoProvider>().userInfo?.id;
      if (userId != null) {
        context.read<VacationBalanceProvider>().getVacationTransactions(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final locale = context.currentLocale();
    final isArabic = context.isArabic();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.vacationBalanceRequestLine,
          backBtn: true,
        ),
        body: Consumer<VacationBalanceProvider>(
          builder: (context, loading, _) {
            final provider = context.read<VacationBalanceProvider>();
            final balance = provider.vacationBalance;
            final transactions = provider.vacationTransactions;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: CustomScrollView(
                slivers: [
                  headerSection(local.leavesBalance),
                  leavesGrid(theme, local, isArabic, balance, provider.loading),
                  headerSection(local.consumedLeaves),
                  consumedGrid(theme, local, isArabic, balance, provider.loading),
                  headerSection(local.leavesTransactions),
                  transactionsList(theme, local, isArabic, locale,transactions, provider.loading),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}
