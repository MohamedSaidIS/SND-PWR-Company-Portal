import 'package:company_portal/l10n/app_localizations.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/custom_app_bar.dart';
import '../../utils/kpi_helper.dart';

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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
          child: CustomScrollView(
            slivers: [
              // Initial Balance row
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0,top: 5.0),
                  child: Text(
                    local.leavesBalance,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverGrid(
                delegate: SliverChildListDelegate(
                  [
                    leavesTypesWidget(theme, local.totalBalance, "14", local,isArabic),
                    leavesTypesWidget(theme, local.currentBalance, "14", local, isArabic),
                  ],
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                ),
              ),
               SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0,top: 5.0),
                  child: Text(
                    local.remainLeaves,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverGrid(
                delegate: SliverChildListDelegate(
                  [
                    leavesTypesWidget(theme, local.annualLeave, "14", local, isArabic),
                  ],
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                ),
              ),
               SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0,top: 5.0),
                  child: Text(
                    local.leavesTransactions,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: 10,
                itemBuilder: (index, context) {
                  return vacationTransaction(theme, local, locale,isArabic);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget vacationTransaction(ThemeData theme, AppLocalizations local, String locale, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.colorScheme.primary.withValues(alpha:0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(local.annualLeave, style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.w600),),
                  Text(DateFormat.yMMMd(locale).format(DateTime.now()), style: TextStyle(color: theme.colorScheme.primary))
                ],
              ),
              Text("${convertedToArabicNumber(3, isArabic)} ${local.days}", style: TextStyle(color: theme.colorScheme.primary),),
            ],
          ),
        ),
      ),
    );
  }

  Widget leavesTypesWidget(ThemeData theme, String leaveText, String leaveAmount, AppLocalizations local, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: leaveText == local.annualLeave
                ? theme.colorScheme.secondary
                : theme.colorScheme.primary,
            width: 1,
          ),
          color: leaveText == local.annualLeave
              ? theme.colorScheme.secondary.withValues(alpha:0.15)
              : theme.colorScheme.primary.withValues(alpha:0.15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leaveText,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                convertedToArabicNumber(leaveAmount, isArabic),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: leaveText == local.annualLeave
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
