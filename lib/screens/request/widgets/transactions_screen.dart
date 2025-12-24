import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/export_import.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VacationBalanceProvider>();
    final transactions = provider.vacationTransactions;
    final local = context.local;
    final theme = context.theme;
    final locale = context.currentLocale();
    final isArabic = context.isArabic();

    return transactions.isEmpty
        ? noDataExist("There is No Transactions", theme)
        : (provider.loading)
            ? loadingWidget(theme)
            : SliverList.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return vacationTransactionTile(
                    theme,
                    local,
                    locale,
                    isArabic,
                    transactions[index],
                  );
                },
              );
  }
}

Widget vacationTransactionTile(
    ThemeData theme,
    AppLocalizations local,
    String locale,
    bool isArabic,
    VacationTransaction item,
    ) {
  final absenceName = {
    "سنوي-راتب": local.annualLeave,
    "مأمورية": local.mission,
    "001": local.sickLeave,
    "009": local.compensatoryLeave,
    "006": local.umrahLeave,
    "008": local.bereavementLeave,
    "إذن": local.permission
  }[item.absenceCode] ??
      local.annualLeave;

  String permissionDuration = "";
  if(absenceName == local.permission){
    Duration difference = item.endDate.difference(item.startDate);
    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);
    permissionDuration = "${hours > 0 ? '${convertedToArabicNumber(hours, isArabic)} hr ' : ''}${minutes > 0 ? '${convertedToArabicNumber(minutes, isArabic)} min' : ''}";
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(theme, absenceName, item, isArabic, local, permissionDuration, absenceName == local.permission),
            const SizedBox(
              height: 8,
            ),
            buildDateRow(item, local, locale),
          ],
        ),
      ),
    ),
  );
}