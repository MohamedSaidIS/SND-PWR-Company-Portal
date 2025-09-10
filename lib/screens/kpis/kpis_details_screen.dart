import 'dart:core';
import 'package:company_portal/models/remote/sales_kpi.dart';
import 'package:company_portal/utils/kpi_calculation_handler.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/custom_app_bar.dart';

import '../../utils/app_notifier.dart';

class KpisDetailsScreen extends StatefulWidget {
  final List<SalesKPI> salesKpis;
  final String title;
  final WeeklyKPI currentWeek;
  final int selectedMonth;

  const KpisDetailsScreen(
      {super.key,
      required this.salesKpis,
      required this.title,
      required this.currentWeek,
      required this.selectedMonth});

  @override
  State<KpisDetailsScreen> createState() => _KpisDetailsScreenState();
}

class _KpisDetailsScreenState extends State<KpisDetailsScreen> {
  late List<SalesKPI> salesKpis;
  List<WeeklyKPI> weeksInMonth = [];
  List<DailyKPI> daysInWeek = [];
  List<DailyKPI> daysInMonth = [];
  bool salesKpiListOverLength = false;

  @override
  void initState() {
    super.initState();
    salesKpis = widget.salesKpis;

    weeksInMonth = KpiCalculationHandler.calculateWeeklySales(
        salesKpis, widget.selectedMonth);
    print("CurrentWeek: ${widget.currentWeek.weekNumber}");

    daysInWeek = KpiCalculationHandler.calculateDailySalesPerWeek(
        salesKpis, widget.currentWeek.weekNumber, 2025);
    daysInMonth = KpiCalculationHandler.calculateDailySalesPerMonth(
        salesKpis, widget.selectedMonth, 2025);

    salesKpiListOverLength = daysInMonth.length > 10 ? true : false;
    print("SalesKpiListOverLength $salesKpiListOverLength");
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
    if (salesKpiListOverLength && widget.title == "Daily KPI") {
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
            toY: kpi.totalSales,
            color: Colors.green,
            //KpiCalculationHandler.getDailyKPiBarColor(kpi),
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
      AppNotifier.printFunction(
          "MonthlyTotals", weeksInMonth.last.totalSales.toString());
    }

    return weeksInMonth.asMap().entries.map((entry) {
      final weekIndex = entry.key;
      final weekTotalKpi = entry.value.totalSales;

      return BarChartGroupData(
        x: weekIndex,
        barRods: [
          BarChartRodData(
            toY: weekTotalKpi,
            color: Colors.orange,
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
      AppNotifier.printFunction("weeklyTotals", "${i.date} ${i.totalSales}");
    }

    return daysInWeek.asMap().entries.map((entry) {
      final dayIndex = entry.key;
      final dayTotalKpi = entry.value.totalSales;

      return BarChartGroupData(
        x: dayIndex,
        barRods: [
          BarChartRodData(
            toY: dayTotalKpi,
            color: Colors.orange,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2), topRight: Radius.circular(2)),
            width: 11,
          ),
        ],
      );
    }).toList();
  }

  List<BarChartGroupData> getSuitableBarGroups(
      List<SalesKPI> data, String title) {
    if (title == "Daily KPI") {
      return _buildDailyBarGroups(data);
    } else if (title == "Monthly KPI") {
      return _buildMonthlyBarGroups(data);
    } else {
      return _buildWeeklyBarGroups(data);
    }
  }

  Widget getX_axisTitles(double value, String title, List<SalesKPI> salesKpis) {
    Widget widget = const Text("");
    if (title == "Daily KPI") {
        print("Length ${salesKpis.length}");
        widget = getDailyX_axisTitles(value, salesKpis);
    } else if (title == "Monthly KPI") {
      if (weeksInMonth.isNotEmpty && value.toInt() < weeksInMonth.length) {
        return Text("W${weeksInMonth[value.toInt()].weekNumber}");
      }
      return const Text("");
    } else {
      if (daysInWeek.isNotEmpty && value.toInt() < daysInWeek.length) {
        widget = Text(daysInWeek[value.toInt()].dayName);
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

  double getMaxValue(List<SalesKPI> data, List<WeeklyKPI> weeksData) {
    if (widget.title == "Daily KPI") {
      return KpiCalculationHandler.calcDailyMaxY(data);
    } else if (widget.title == "Monthly KPI") {
      return KpiCalculationHandler.calcMonthlyMaxY(weeksData);
    } else {
      return KpiCalculationHandler.calcWeeklyMaxY(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

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
                // KPI summary cards
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // KPIBox(title: "Sales", value: "12.3K", color: Colors.green),
                    // KPIBox(title: "Leads", value: "875", color: Colors.blue),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: getMaxValue(widget.salesKpis, weeksInMonth),
                      barGroups:
                          getSuitableBarGroups(widget.salesKpis, widget.title),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              getTitlesWidget: (value, meta) {
                                return getX_axisTitles(
                                    value, widget.title, widget.salesKpis);
                              }),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20)
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
  final String value;
  final Color color;

  const KPIBox(
      {super.key,
      required this.title,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: color.withOpacity(0.1),
      child: Container(
        width: 150,
        height: 80,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
