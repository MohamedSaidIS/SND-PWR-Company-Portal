import 'dart:core';

import 'package:company_portal/screens/kpis/widgets/kpi_calculator.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../common/custom_app_bar.dart';
import '../../models/sales_kpi.dart';
import '../../utils/app_notifier.dart';

class KpisDetailsScreen extends StatefulWidget {
  final List<SalesKPI> salesKpis;
  final String title;

  const KpisDetailsScreen(
      {super.key, required this.salesKpis, required this.title});

  @override
  State<KpisDetailsScreen> createState() => _KpisDetailsScreenState();
}

class _KpisDetailsScreenState extends State<KpisDetailsScreen> {
  late List<SalesKPI> salesKpis;
  List<WeeklyKPI> weeksInMonth = [];
  List<DailyKPI> daysInWeek = [];

  @override
  void initState() {
    super.initState();
    salesKpis = widget.salesKpis;

    weeksInMonth = KpiCalculator.calculateWeeklySales(salesKpis);
    daysInWeek = KpiCalculator.calculateDailySalesPerWeek(salesKpis);
  }
  List<BarChartGroupData> _buildDailyBarGroups(List<SalesKPI> data) {
    final subList = data.take(4).toList();
    return subList.asMap().entries.map((entry) {
      final index = entry.key;
      final kpi = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: kpi.dailySalesAmount,
            color: KpiCalculator.getDailyKPiBarColor(kpi),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2), topRight: Radius.circular(2)),
            width: 11,
          ),
        ],
      );
    }).toList();
  }

  List<BarChartGroupData> _buildMonthlyBarGroups(List<SalesKPI> data) {
    // weeksInMonth = KpiCalculator.calculateWeeklySales(data);

    AppNotifier.printFunction("MonthlyTotals", weeksInMonth.first.totalSales.toString());

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
    // final weeklyTotals = KpiCalculator.getWeeklyKPIs(data);

    AppNotifier.printFunction("weeklyTotals", daysInWeek.first.totalSales.toString());

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

  List<BarChartGroupData> getSuitableBarGroups(List<SalesKPI> data, String title) {
    if (title == "Daily KPI") {
      return _buildDailyBarGroups(data);
    }else if (title == "Monthly KPI"){
      return _buildMonthlyBarGroups(data);
    }else{
      return _buildWeeklyBarGroups(data);
    }
  }


  Widget getX_axisTitles(double value, String title, List<SalesKPI> salesKpis) {
    Widget widget = const Text("");
    if (title == "Daily KPI") {
      if (value.toInt() < salesKpis.length) {
        final date = salesKpis[value.toInt()].transDate;
        widget = Text("${date.day}/${date.month}");
      }
    } else if (title == "Monthly KPI") {
      if (weeksInMonth.isNotEmpty && value.toInt() < weeksInMonth.length) {
        return Text("W${weeksInMonth[value.toInt()].weekNumber}");
      }
      return const Text("");
    } else {
      //final weekDays = KpiCalculator.getCurrentWeekDays(salesKpis);
      if (daysInWeek.isNotEmpty && value.toInt() < daysInWeek.length) {
        widget = Text(daysInWeek[value.toInt()].dayName);
      }
    }
    return widget;
  }

  double getMaxValue(List<SalesKPI> data, List<WeeklyKPI> weeksData) {
    if(widget.title == "Daily KPI"){
      return KpiCalculator.calcDailyMaxY(data);
    }else if(widget.title == "Monthly KPI"){
      return KpiCalculator.calcMonthlyMaxY(weeksData);
    }else{
      return KpiCalculator.calcWeeklyMaxY(data);
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
        body: Padding(
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
                    barGroups: getSuitableBarGroups(widget.salesKpis, widget.title),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return getX_axisTitles(value, widget.title, widget.salesKpis);
                            }),
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
