import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/export_import.dart';

List<BarChartGroupData> getBarGroups(
  String currentView,
  BuildContext context,
  List<DailyKPI> daysInWeek,
  List<DailyKPI> daysInMonth,
  List<WeeklyKPI> weeksInMonth,
  List<int> weeksNumberInMonth,
  double monthlyTarget,
  bool salesKpiListOverLength,
) {
  if (currentView == context.local.dailyKpi) {
    return daysInMonth.asMap().entries.map((e) {
      final kpi = e.value;
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: double.parse(kpi.totalSales.toStringAsFixed(2)),
            color: KpiUIHelper.getDailyKPiBarColor(kpi, monthlyTarget),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            width: salesKpiListOverLength ? 4 : 10,
          ),
        ],
      );
    }).toList();
  } else if (currentView == context.local.monthlyKpi) {
    if (daysInMonth.isEmpty) {
      return weeksNumberInMonth.asMap().entries.map((e) {
        return BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(
              toY: 0.0,
              color: Colors.grey,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
              width: salesKpiListOverLength ? 4 : 10,
            ),
          ],
        );
      }).toList();
    } else {
      return weeksInMonth.asMap().entries.map((e) {
        final week = e.value;
        return BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(
              toY: double.parse(week.totalSales.toStringAsFixed(2)),
              color: KpiUIHelper.getMonthlyKPiBarColor(week, monthlyTarget),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
              width: 10,
            ),
          ],
        );
      }).toList();
    }
  } else {
    return daysInWeek.asMap().entries.map((e) {
      final day = e.value;
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: double.parse(day.totalSales.toStringAsFixed(2)),
            color: KpiUIHelper.getWeeklyKPiBarColor(day, monthlyTarget),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            width: 10,
          ),
        ],
      );
    }).toList();
  }
}

Widget getXAsis(
    double value,
    BuildContext context,
    String currentView,
    bool salesKpiListOverLength,
    List<int> weeksNumberInMonth,
    List<DailyKPI> daysInWeek,
    List<DailyKPI> daysInMonth,
    List<WeeklyKPI> weeksInMonth) {
  final local = context.local;
  final isArabic = context.isArabic();

  if (currentView == local.dailyKpi) {
    final date = daysInMonth[value.toInt()].date;
    return Transform.rotate(
      angle: salesKpiListOverLength ? -0.8 : 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Text("${date.day}/${date.month}",
            style: const TextStyle(fontSize: 10)),
      ),
    );
  } else if (currentView == local.monthlyKpi) {
    // ✅ إظهار الأسابيع حتى لو ما في بيانات
    if (weeksNumberInMonth.isNotEmpty &&
        value.toInt() < weeksNumberInMonth.length) {
      return Text(
        "W${weeksNumberInMonth[value.toInt()]}",
        style: const TextStyle(fontSize: 10),
      );
    }

    // كخطة احتياطية لو فاضي:
    if (weeksInMonth.isNotEmpty && value.toInt() < weeksInMonth.length) {
      return Text(
        "W${weeksInMonth[value.toInt()].weekNumber}",
        style: const TextStyle(fontSize: 10),
      );
    }

    // لو كله فاضي، نرجع فقط مربع فارغ
    return const SizedBox();
  } else {
    if (value.toInt() < daysInWeek.length) {
      final day = daysInWeek[value.toInt()].dayName;
      return Transform.rotate(
        angle: isArabic ? -0.4 : 0,
        child: Text(day, style: const TextStyle(fontSize: 10)),
      );
    }
  }
  return const SizedBox();
}

double getMaxY(
  String currentView,
  BuildContext context,
  List<SalesKPI> salesKpis,
  List<DailyKPI> daysInWeek,
  List<WeeklyKPI> weeksInMonth,
) {
  final local = context.local;
  if (currentView == local.dailyKpi) {
    return KpiCalculationHandler.calcDailyMaxY(salesKpis);
  } else if (currentView == local.monthlyKpi) {
    return KpiCalculationHandler.calcMonthlyMaxY(weeksInMonth);
  } else {
    return KpiCalculationHandler.calcWeeklyMaxY(daysInWeek);
  }
}

Widget buildLegend(BuildContext context) {
  final theme = context.theme;
  final local = context.local;

  final legends = [
    {'color': Colors.blue, 'label': local.exceeded},
    {'color': Colors.green, 'label': local.reached},
    {'color': Colors.orange, 'label': local.near},
    {'color': Colors.red, 'label': local.below},
  ];

  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: legends.map((item) {
        return Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item['label'] as String,
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }).toList(),
    ),
  );
}

void handleOrientation(bool salesKpiListOverLength) {
  if (salesKpiListOverLength) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

Widget buildChart(
    BuildContext context,
    String currentView,
    List<int> weeksNumberInMonth,
    List<SalesKPI> salesKpis,
    List<DailyKPI> daysInWeek,
    List<DailyKPI> daysInMonth,
    List<WeeklyKPI> weeksInMonth,
    double monthlyTarget,
    bool salesKpiListOverLength) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
    child: BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
        ),
        alignment: BarChartAlignment.spaceEvenly,
        maxY: getMaxY(
          currentView,
          context,
          salesKpis,
          daysInWeek,
          weeksInMonth,
        ),
        barGroups: getBarGroups(
          currentView,
          context,
          daysInWeek,
          daysInMonth,
          weeksInMonth,
          weeksNumberInMonth,
          monthlyTarget,
          salesKpiListOverLength,
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            top: BorderSide.none,
            left: BorderSide.none,
            right: BorderSide.none,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) => getXAsis(
                v,
                context,
                currentView,
                salesKpiListOverLength,
                weeksNumberInMonth,
                daysInWeek,
                daysInMonth,
                weeksInMonth,
              ),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
      ),
      swapAnimationDuration: const Duration(milliseconds: 500),
      swapAnimationCurve: Curves.easeOutCubic,
    ),
  );
}

String getKpiValueDueDate(AppLocalizations local, bool isArabic, String title,
    List<SalesKPI> salesKpi, int selectedMonth, int? selectedWeek) {
  switch (title) {
    case var t when t == local.dailyKpi:
      return KpiCalculationHandler.getLastDayName(
        salesKpi,
        selectedMonth,
        selectedWeek!,
        isArabic,
      );
    case var t when t == local.weeklyKpi:
      final weekNum = selectedWeek ??
          (salesKpi.isNotEmpty
              ? KpiCalculationHandler.getWeekNumber(salesKpi.last.transDate)
              : DateTime.now().year);

      final translatedWeek = convertedToArabicNumber(weekNum, isArabic);
      return "${local.week}: $translatedWeek";

    default:
      return KpiCalculationHandler.getMonthName(
        salesKpi,
        selectedMonth,
        isArabic,
      );
  }
}

Widget buildPieChartDateAndAchieved(
  AppLocalizations local,
  bool isArabic,
  String title,
  List<SalesKPI> salesKpi,
  int selectedMonth,
  int? selectedWeek,
  ThemeData theme,
  double achieved,
) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 2.0),
        child: Text(
          getKpiValueDueDate(
              local, isArabic, title, salesKpi, selectedMonth, selectedWeek),
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.secondary),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          "${local.achieved}: ${convertedToArabicNumber(achieved.toStringAsFixed(2), isArabic)}",
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}

Widget buildPieChart(double achieved, double target, num percent, bool isArabic){
  return  Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: PieChart(
        PieChartData(
          startDegreeOffset: -90,
          sectionsSpace: 0,
          borderData: FlBorderData(show: false),
          sections: [
            PieChartSectionData(
              color: achieved == 0.0
                  ? Colors.white.withValues(alpha: 0.6)
                  : KpiUIHelper.getPieChartColor(percent),
              value: achieved == 0.0 ? 20 : achieved,
              title: achieved == 0.0 ? '' : '${convertedToArabicNumber(percent.toStringAsFixed(2), isArabic)}%',
              radius: 50,
              titleStyle: TextStyle(
                color: percent > 15 ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            PieChartSectionData(
              color: Colors.white.withValues(alpha: 0.6),
              value: (target - achieved).clamp(0, target),
              title: '',
              radius: 45,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildPieChartTitle(String title, ThemeData theme){
  return Text(
    title,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.secondary,
    ),
  );
}
