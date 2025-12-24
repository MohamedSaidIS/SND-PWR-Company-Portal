import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/export_import.dart';

class SalesKpisDetailsScreen extends StatefulWidget {
  final List<SalesKPI> salesKpis;
  final String initialTitle;
  final WeeklyKPI currentWeek;
  final int selectedMonth;
  final List<DailyKPI> weeklyValues;

  const SalesKpisDetailsScreen({
    super.key,
    required this.salesKpis,
    required this.initialTitle,
    required this.currentWeek,
    required this.selectedMonth,
    required this.weeklyValues,
  });

  @override
  State<SalesKpisDetailsScreen> createState() => _SalesKpisDetailsScreenState();
}

class _SalesKpisDetailsScreenState extends State<SalesKpisDetailsScreen> {
  late String currentView;
  late double monthlyTarget;
  late List<WeeklyKPI> weeksInMonth = [];
  late List<DailyKPI> daysInWeek = [];
  late List<DailyKPI> daysInMonth = [];
  late List<int> weeksNumberInMonth = [];
  bool salesKpiListOverLength = false;

  @override
  void initState() {
    super.initState();
    currentView = widget.initialTitle;
    monthlyTarget =
        widget.salesKpis.isNotEmpty ? widget.salesKpis.first.monthlyTarget : 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculateData();
    handleOrientation(salesKpiListOverLength);
  }

  void _calculateData() {
    weeksInMonth = [];
    weeksNumberInMonth = [];
    daysInWeek = [];
    daysInMonth = [];
    weeksInMonth = KpiCalculationHandler.calculateWeeklySales(
        List.from(widget.salesKpis), widget.selectedMonth);
    weeksNumberInMonth = KpiCalculationHandler.getWeekNumbersInMonth(
        DateTime.now().year, widget.selectedMonth);
    daysInWeek = KpiCalculationHandler.calculateDailySalesPerWeek(
        List.from(widget.salesKpis),
        widget.currentWeek.weekNumber,
        DateTime.now().year,
        List.from(widget.weeklyValues));
    for (var e in daysInWeek) {
      AppNotifier.logWithScreen("KpiDetailsScreen:","D => ${e.dayName} ${e.totalSales}");
    }
    daysInMonth = KpiCalculationHandler.calculateDailySalesPerMonth(
        List.from(widget.salesKpis), widget.selectedMonth, DateTime.now().year);
    if (currentView == context.local.dailyKpi) {
      salesKpiListOverLength = daysInMonth.length > 10;
    } else {
      salesKpiListOverLength = false;
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Widget _buildSegmentedSelector() {
    final local = context.local;
    final options = [local.dailyKpi, local.weeklyKpi, local.monthlyKpi];
    return SegmentedButton<String>(
      segments: options
          .map(
            (e) => ButtonSegment(
              value: e,
              label: Text(e, style: const TextStyle(fontSize: 12)),
            ),
          )
          .toList(),
      selected: {currentView},
      onSelectionChanged: (val) {
        setState(() {
          currentView = val.first;
          _calculateData();
          handleOrientation(salesKpiListOverLength);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.kpisDetails,
          backBtn: true,
        ),
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isLandscape
                ? Column(
                    key: const ValueKey('landscape'),
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildLegend(context),
                            _buildSegmentedSelector(),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5),
                          child: buildChart(
                            context,
                            currentView,
                            weeksNumberInMonth,
                            List.from(widget.salesKpis),
                            daysInWeek,
                            daysInMonth,
                            weeksInMonth,
                            monthlyTarget,
                            salesKpiListOverLength,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    key: const ValueKey('portrait'),
                    children: [
                      buildLegend(context),
                      const SizedBox(height: 10),
                      _buildSegmentedSelector(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: buildChart(
                          context,
                          currentView,
                          weeksNumberInMonth,
                          List.from(widget.salesKpis),
                          daysInWeek,
                          daysInMonth,
                          weeksInMonth,
                          monthlyTarget,
                          salesKpiListOverLength,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
