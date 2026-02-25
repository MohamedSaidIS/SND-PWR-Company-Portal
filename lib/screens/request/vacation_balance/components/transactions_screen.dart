import 'package:company_portal/screens/request/vacation_balance/components/transaction_item.dart';
import 'package:company_portal/screens/request/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/export_import.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VacationBalanceProvider>();
    final transactions = provider.vacationTransactions;
    final theme = context.theme;

    return transactions.isEmpty
        ? const EmptyScreen(title: "There is No Transactions")
        : (provider.transactionLoading)
            ? SliverToBoxAdapter(child: AppNotifier.loadingWidget(theme))
            : SliverList.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionItem(
                    item: transactions[index],
                  );
                },
              );
  }
}
