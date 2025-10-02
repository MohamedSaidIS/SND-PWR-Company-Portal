import 'dart:core';
import 'package:company_portal/l10n/app_localizations.dart';
import 'package:company_portal/models/remote/sales_kpi.dart';
import 'package:company_portal/utils/kpi_calculation_handler.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/custom_app_bar.dart';

import '../../utils/app_notifier.dart';

class SalesKpisDetailsScreen extends StatefulWidget {
  final List<SalesKPI> salesKpis;
  final String title;
  final WeeklyKPI currentWeek;
  final int selectedMonth;
  final List<DailyKPI> weeklyValues;

  const SalesKpisDetailsScreen({
    super.key,
    required this.salesKpis,
    required this.title,
    required this.currentWeek,
    required this.selectedMonth,
    required this.weeklyValues,
  });

  @override
  State<SalesKpisDetailsScreen> createState() => _SalesKpisDetailsScreenState();
}

class _SalesKpisDetailsScreenState extends State<SalesKpisDetailsScreen> {
  late List<SalesKPI> salesKpis;
  late double monthlyTarget;
  List<WeeklyKPI> weeksInMonth = [];
  List<DailyKPI> daysInWeek = [];
  List<DailyKPI> daysInMonth = [];
  List<DailyKPI> weeklyValues = [];
  bool salesKpiListOverLength = false;

  @override
  void initState() {
    super.initState();
    salesKpis = widget.salesKpis;
    weeklyValues = widget.weeklyValues;

    monthlyTarget = salesKpis.first.monthlyTarget;

    weeksInMonth = KpiCalculationHandler.calculateWeeklySales(
        salesKpis, widget.selectedMonth);
    AppNotifier.logWithScreen("KPI Details Screen","CurrentWeek: ${widget.currentWeek.weekNumber}");
    AppNotifier.logWithScreen("KPI Details Screen","WeeklyValues: ${weeklyValues.length}");

    daysInWeek = KpiCalculationHandler.calculateDailySalesPerWeek(
        salesKpis, widget.currentWeek.weekNumber,
        DateTime.now().year, weeklyValues);

    daysInMonth = KpiCalculationHandler.calculateDailySalesPerMonth(
        salesKpis, widget.selectedMonth, DateTime.now().year);

    salesKpiListOverLength = daysInMonth.length > 10 ? true : false;
    AppNotifier.logWithScreen("KPI Details Screen","SalesKpiListOverLength $salesKpiListOverLength");

    handleOrientation(salesKpiListOverLength);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
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

  List<BarChartGroupData> _buildDailyBarGroups(List<SalesKPI> data) {
    return daysInMonth.asMap().entries.map((entry) {
      final index = entry.key;
      final kpi = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: double.parse(kpi.totalSales.toStringAsFixed(2)),
            color: KpiCalculationHandler.getDailyKPiBarColor(
                daysInMonth[index], monthlyTarget),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2), topRight: Radius.circular(2)),
            width: salesKpiListOverLength ? 4 : 11,
          ),
        ],
      );
    }).toList();
  }

  List<BarChartGroupData> _buildMonthlyBarGroups(List<SalesKPI> data) {
    if (weeksInMonth.isNotEmpty) {
      AppNotifier.logWithScreen(
          "MonthlyTotals", weeksInMonth.last.totalSales.toString());
    }

    return weeksInMonth.asMap().entries.map((entry) {
      final weekIndex = entry.key;
      final weekTotalKpi = entry.value.totalSales;

      return BarChartGroupData(
        x: weekIndex,
        barRods: [
          BarChartRodData(
            toY: double.parse(weekTotalKpi.toStringAsFixed(2)),
            color: KpiCalculationHandler.getMonthlyKPiBarColor(
                weeksInMonth[weekIndex], monthlyTarget),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2), topRight: Radius.circular(2)),
            width: 11,
          ),
        ],
      );
    }).toList();
  }

  List<BarChartGroupData> _buildWeeklyBarGroups(List<SalesKPI> data) {
    for (var i in daysInWeek) {
      AppNotifier.logWithScreen("weeklyTotals", "${i.date} ${i.totalSales}");
    }

    return daysInWeek.asMap().entries.map((entry) {
      final dayIndex = entry.key;
      final dayTotalKpi = entry.value.totalSales;

      return BarChartGroupData(
        x: dayIndex,
        barRods: [
          BarChartRodData(
            toY: double.parse(dayTotalKpi.toStringAsFixed(2)),
            color: KpiCalculationHandler.getWeeklyKPiBarColor(
                daysInWeek[dayIndex], monthlyTarget),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2), topRight: Radius.circular(2)),
            width: 11,
          ),
        ],
      );
    }).toList();
  }

  List<BarChartGroupData> getSuitableBarGroups(
      List<SalesKPI> data, String title, AppLocalizations local) {
    if (title == local.dailyKpi) {
      return _buildDailyBarGroups(data);
    } else if (title == local.monthlyKpi) {
      return _buildMonthlyBarGroups(data);
    } else {
      return _buildWeeklyBarGroups(data);
    }
  }

  Widget getX_axisTitles(double value, String title, List<SalesKPI> salesKpis, bool isArabic, AppLocalizations local) {
    Widget widget = const Text("");
    if (title == local.dailyKpi) {
      AppNotifier.logWithScreen("KPI Details Screen","Length ${salesKpis.length}");
      widget = getDailyX_axisTitles(value, salesKpis);
    } else if (title == local.monthlyKpi) {
      if (weeksInMonth.isNotEmpty && value.toInt() < weeksInMonth.length) {
        return Text("W${weeksInMonth[value.toInt()].weekNumber}");
      }
      return const Text("");
    } else {
      if (daysInWeek.isNotEmpty && value.toInt() < daysInWeek.length) {
        widget = isArabic
            ? Padding(
          padding: const EdgeInsets.only(top: 7.0),
          child: Transform.rotate(
            angle: -0.4,
            child: Text(
              daysInWeek[value.toInt()].dayName,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        )
            : Text(daysInWeek[value.toInt()].dayName);
      }
    }
    return widget;
  }

  Widget getDailyX_axisTitles(double value, List<SalesKPI> salesKpis) {
    final date = daysInMonth.elementAt(value.toInt()).date;
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: salesKpiListOverLength
          ? Transform.rotate(
        angle: -0.8,
        child: Text(
          "${date.day}/${date.month}",
          style: const TextStyle(fontSize: 10),
        ),
      )
          : Text(
        "${date.day}/${date.month}",
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  double getMaxValue(List<SalesKPI> data, List<WeeklyKPI> weeksInMonth,
      List<DailyKPI> daysInWeek, AppLocalizations local) {
    if (widget.title == local.dailyKpi) {
      return KpiCalculationHandler.calcDailyMaxY(data);
    } else if (widget.title == local.monthlyKpi) {
      return KpiCalculationHandler.calcMonthlyMaxY(weeksInMonth);
    } else {
      return KpiCalculationHandler.calcWeeklyMaxY(daysInWeek);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final isArabic = context.isArabic();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: CustomAppBar(
          title: local.kpisDetails,
          backBtn: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KPIBox(title: local.exceeded, color: Colors.blue),
                    KPIBox(title: local.reached, color: Colors.green),
                    KPIBox(title: local.near, color: Colors.orange),
                    KPIBox(title: local.below, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: getMaxValue(
                            widget.salesKpis, weeksInMonth, daysInWeek, local),
                        barGroups: getSuitableBarGroups(
                            widget.salesKpis, widget.title, local),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 20,
                                getTitlesWidget: (value, meta) {
                                  return getX_axisTitles(value, widget.title,
                                      widget.salesKpis, isArabic, local);
                                }),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 7,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KPIBox extends StatelessWidget {
  final String title;
  final Color color;

  const KPIBox({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.square,
          color: color,
        ),
        Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
