import 'package:company_portal/l10n/app_localizations.dart';
import 'package:company_portal/models/remote/vacation_transaction.dart';
import 'package:company_portal/providers/vacation_balance_provider.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../common/custom_app_bar.dart';
import '../../utils/kpi_helper.dart';

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
      context.read<VacationBalanceProvider>().getVacationTransactions("e662e0d0-25d6-41a1-8bf3-55326a51cc16");
    });
  }

  @override
  Widget build(BuildContext context) {
    final vacationBalanceProvider = context.watch<VacationBalanceProvider>();
    final vacationTransactionsList = vacationBalanceProvider
        .vacationTransactions;
    final vacationBalance = vacationBalanceProvider.vacationBalance;
    final theme = context.theme;
    final local = context.local;
    final locale = context.currentLocale();
    final isArabic = context.isArabic();

    if(vacationBalance == null) return AppNotifier.loadingWidget(theme);

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
                  padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                  child: Text(
                    local.leavesBalance,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              vacationBalanceProvider.loading
                  ? SliverToBoxAdapter(child: AppNotifier.loadingWidget(theme))
                  : SliverGrid(
                delegate: SliverChildListDelegate(
                  [
                    leavesTypesWidget(
                        theme, local.totalBalance,
                        vacationBalance.totalBalance.toString(), local,
                        isArabic),
                    leavesTypesWidget(
                        theme, local.remainBalance,
                        vacationBalance.totalRemainingToDate.toString(), local,
                        isArabic),
                  ],
                ),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                  child: Text(
                    local.consumedLeaves,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              vacationBalanceProvider.loading
                  ? SliverToBoxAdapter(child: AppNotifier.loadingWidget(theme))
                  : SliverGrid(
                delegate: SliverChildListDelegate(
                  [
                    leavesTypesWidget(
                        theme, local.consumedLeaves,
                        vacationBalance!.newBalance.toString(), local,
                        isArabic),
                  ],
                ),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                  child: Text(
                    local.leavesTransactions,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              vacationBalanceProvider.loading
                  ? SliverToBoxAdapter(child: AppNotifier.loadingWidget(theme))
                  : SliverList.builder(
                itemCount: vacationTransactionsList.length,
                itemBuilder: (context, index) {
                  return vacationTransaction(theme, local, locale,
                      isArabic, vacationTransactionsList[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }



  String getAbsenceCodeHeader(String absenceCode, AppLocalizations local) {
    var absenceCodeHeader = "";
    switch (absenceCode) {
      case "سنوي-راتب":
        absenceCodeHeader = local.annualLeave;
        break;
      case "مأمورية":
        absenceCodeHeader = local.mission;
        break;
      case "001":
        absenceCodeHeader = local.sickLeave;
        break;
      case "009":
        absenceCodeHeader = local.compensatoryLeave;
        break;
      case "006":
        absenceCodeHeader = local.umrahLeave;
        break;
      case "008":
        absenceCodeHeader = local.bereavementLeave;
        break;
      default:
        absenceCodeHeader = "Annual Leave";
        break;
    }
    return absenceCodeHeader;
  }

  Widget vacationTransaction(ThemeData theme, AppLocalizations local,
      String locale, bool isArabic, VacationTransaction vacationBalanceItem) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getAbsenceCodeHeader(
                        vacationBalanceItem.absenceCode, local),
                    style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${convertedToArabicNumber(
                      double.parse(vacationBalanceItem.durationDays.toString())
                          .round(),
                      isArabic,
                    )} ${local.days}",
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text.rich(
                TextSpan(
                  text: "${local.from}  ",
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  children: [
                    TextSpan(
                      text: DateFormat.yMMMd(locale)
                          .format(vacationBalanceItem.startDate),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "  —  ${local.to}  ",
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    TextSpan(
                      text: DateFormat.yMMMd(locale)
                          .format(vacationBalanceItem.endDate),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget leavesTypesWidget(ThemeData theme, String leaveText,
      String leaveAmount, AppLocalizations local, bool isArabic,) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: leaveText == local.consumedLeaves
                ? theme.colorScheme.secondary
                : theme.colorScheme.primary,
            width: 1,
          ),
          color: leaveText == local.consumedLeaves
              ? theme.colorScheme.secondary.withValues(alpha: 0.15)
              : theme.colorScheme.primary.withValues(alpha: 0.15),
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
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                convertedToArabicNumber(leaveAmount, isArabic),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: leaveText == local.consumedLeaves
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
