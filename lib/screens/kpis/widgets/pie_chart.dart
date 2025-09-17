import 'package:company_portal/l10n/app_localizations.dart';
import 'package:company_portal/models/remote/sales_kpi.dart';
import 'package:company_portal/screens/kpis/kpis_details_screen.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:company_portal/utils/kpi_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../utils/kpi_calculation_handler.dart';

class KpiPieChart extends StatelessWidget {
  final String title;
  final double achieved;
  final double target;
  final List<SalesKPI> salesKpi;
  final WeeklyKPI currentWeek;
  final int selectedMonth;
  final int? selectedWeek;
  final List<DailyKPI> weeklyValues;

  const KpiPieChart({
    super.key,
    required this.title,
    required this.achieved,
    required this.target,
    required this.salesKpi,
    required this.currentWeek,
    required this.selectedMonth,
    required this.selectedWeek,
    this.weeklyValues = const [],
  });

  String getKpiValueDueDate(AppLocalizations local, bool isArabic) {
    print("Selected Month: $selectedMonth");
    if (title == local.dailyKpi) {
      return KpiCalculationHandler.getLastDayName(
          salesKpi, selectedMonth, selectedWeek!, isArabic);
    } else if (title == local.weeklyKpi) {
      var translatedWeekNumber = "";
      if (selectedWeek != null) {
        translatedWeekNumber = convertedToArabicNumber(selectedWeek!, isArabic);
        return "${local.week} : $translatedWeekNumber";
      } else {
        DateTime lastDate = DateTime.now();
        if (salesKpi.isNotEmpty) {
          lastDate = salesKpi.last.transDate;
        }
        translatedWeekNumber = convertedToArabicNumber(KpiCalculationHandler.getWeekNumber(lastDate), isArabic);
        return "${local.week}: $translatedWeekNumber";
      }
    } else {
      return KpiCalculationHandler.getMonthName(salesKpi, selectedMonth, isArabic);
    }
  }



  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final isArabic = context.isArabic();
    final percent = (target == 0) ? 0 : (achieved / target * 100);

    print("Week: $selectedWeek currentWeek: ${currentWeek.weekNumber}");
    print("PieChart: $title, $achieved, $target, $currentWeek, $salesKpi, $selectedMonth, $selectedWeek, $currentWeek");

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.primary.withOpacity(0.1),
      ),
      margin: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => KpisDetailsScreen(
              salesKpis: salesKpi,
              title: title,
              currentWeek: currentWeek,
              selectedMonth: selectedMonth,
              weeklyValues: weeklyValues,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 0,
                    sections: [
                      PieChartSectionData(
                        color: achieved == 0.0 ?Colors.white.withOpacity(0.6):  KpiHelper.getPieChartColor(percent),
                        value: achieved == 0.0 ? 1 : achieved,
                        title: achieved == 0.0 ? '': '${convertedToArabicNumber(percent.toStringAsFixed(2), isArabic)}%',
                        radius: 55,
                        titleStyle: TextStyle(
                          color: percent > 15 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.white.withOpacity(0.6),
                        value: (target - achieved).clamp(0, target),
                        title: '',
                        radius: 45,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                getKpiValueDueDate(local, isArabic),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.secondary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                "${local.achieved}: ${convertedToArabicNumber(achieved.toStringAsFixed(2), isArabic)}",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
