import 'package:flutter/material.dart';
import '../../../utils/export_import.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final isArabic = context.isArabic();
    final percent = (target == 0) ? 0 : (achieved / target * 100);
    final locale = context.currentLocale();

    print("CurrentLocal here $locale");

    final filteredSales = salesKpi.where((item) {
      return item.transDate.month == selectedMonth &&
          item.transDate.year == DateTime.now().year;
    }).toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 6,
          ),
        ],
      ),
      margin: const EdgeInsets.all(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.2),
        highlightColor: Colors.transparent,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SalesKpisDetailsScreen(
              salesKpis: filteredSales,
              initialTitle: title,
              currentWeek: currentWeek,
              selectedMonth: selectedMonth,
              weeklyValues: weeklyValues,
            ),
          ),
        ),
        child: AnimatedScale(
          scale: 1,
          duration: const Duration(milliseconds: 150),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildPieChartTitle(title, theme),
                const SizedBox(height: 6),
                buildPieChart(achieved, target, percent, isArabic),
                buildPieChartDateAndAchieved(local, locale, isArabic, title, salesKpi,
                    selectedMonth, selectedWeek, theme, achieved),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
