import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

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
                  balance?.totalBalance == 0 ? noDataExist("No Leave Balance", theme) : leavesGrid(theme, local, isArabic, balance, provider.loading),
                  headerSection(local.consumedLeaves),
                  balance?.totalBalance == 0 ? noDataExist("No Consumed Balance", theme) : consumedGrid(theme, local, isArabic, balance, provider.loading),
                  headerSection(local.leavesTransactions),
                  transactions.isEmpty? noDataExist("There is No Transactions", theme)
                  : transactionsList(theme, local, isArabic, locale,transactions, provider.loading),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}
