import 'package:company_portal/screens/kpis/widgets/month_week_filter.dart';
import 'package:company_portal/utils/kpi_calculation_handler.dart';
import 'package:company_portal/screens/kpis/widgets/pie_chart.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/custom_app_bar.dart';
import '../../data/user_data.dart';
import '../../models/local/weekly_kpi.dart';
import '../../providers/sales_kpis_provider.dart';
import '../../service/sharedpref_service.dart';
import '../../utils/app_notifier.dart';

class SalesKpiScreen extends StatefulWidget {
  const SalesKpiScreen({
    super.key,
  });

  @override
  State<SalesKpiScreen> createState() => _SalesKpiScreenState();
}

class _SalesKpiScreenState extends State<SalesKpiScreen> {
  bool isUAT = false;
  bool isLoading = false;
  int selectedMonth = DateTime.now().month;
  int?  selectedWeek;
  late List<int> weeksPerMonth;
  List<String> testerIds = [];
  bool isTester = false;

  @override
  void initState() {
    super.initState();

    testerIds = getTesterIds();
    _rebuildWeeks();

    WidgetsBinding.instance.addPostFrameCallback((_) => fetchKpis());

  }

  Future<void> fetchKpis() async {
    final userId = await SharedPrefsHelper().getUserData("UserId");
    AppNotifier.logWithScreen("KPI Dashboard Screen","Fetching KPI for UserId: $userId, isUAT: $isUAT");

    isTester = testerIds.contains(userId);
    AppNotifier.logWithScreen("KPI Dashboard Screen","IsTaster: $isTester");

    if (!context.mounted) return;
    final salesKpiProvider = context.read<SalesKPIProvider>();
    await salesKpiProvider.getSalesKpi('$userId', isUAT: isUAT);

    setState(() => isLoading = false);
  }

  void _rebuildWeeks() {
    weeksPerMonth = KpiCalculationHandler.getWeekNumbersInMonth(
      DateTime.now().year,
      selectedMonth,
    );
    selectedWeek = weeksPerMonth.isNotEmpty ? weeksPerMonth.first : null;
  }

  void _onMonthChanged(int month) {
    setState(() {
      selectedMonth = month;
      _rebuildWeeks();
    });
  }
  void _onWeekChanged(int week) {
    setState(() {
      selectedWeek = week;
    });
  }

  double getAchievedValue(WeeklyKPI currentWeek, List<WeeklyKPI> weekly) {
    if (currentWeek.weekNumber != 0 ||
        selectedWeek == KpiCalculationHandler.getWeekNumber(DateTime.now())) {
      if (currentWeek.totalSales == 0.0) {
        return 0.0;
      } else {
        return currentWeek.totalSales;
      }
    } else {
      return weekly.isNotEmpty ? weekly.last.totalSales : 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final salesKpisProvider = context.watch<SalesKPIProvider>();
    final salesKpis = salesKpisProvider.kpiList ?? [];
    final isLoading = salesKpisProvider.loading;
    final theme = context.theme;
    final local = context.local;
    double daily = 0.0, monthly = 0.0, monthlyTarget = 0.0;
    int currentWeekNumber = 0;
    List<WeeklyKPI> weekly = [];
    var currentWeek = WeeklyKPI(weekNumber: 0, totalSales: 0.0, monthNumber: 0);

    final startDate = KpiCalculationHandler.getIsoWeekStart(DateTime.now().year, selectedWeek!);

    final weeklyValue = KpiCalculationHandler.generateDays(startDate, local);

    if (salesKpis.isNotEmpty) {
      AppNotifier.logWithScreen("KPI Dashboard Screen","SalesKpis: ${salesKpis[0].lastSalesAmount} ");

      monthlyTarget = salesKpis.isNotEmpty ? salesKpis.last.monthlyTarget : 0.0;
      daily = KpiCalculationHandler.calculateDailySales(
          salesKpis, selectedMonth, selectedWeek!);
      weekly =
          KpiCalculationHandler.calculateWeeklySales(salesKpis, selectedMonth);
      monthly =
          KpiCalculationHandler.calculateMonthlySales(salesKpis, selectedMonth);
      currentWeekNumber = KpiCalculationHandler.getWeekNumber(DateTime.now());

      if (weekly.isNotEmpty) {
        for (var i in weekly) {
          AppNotifier.logWithScreen("KPI Dashboard Screen","weekly: ${i.weekNumber}");
        }
        if (currentWeekNumber == selectedWeek) {
          currentWeek = weekly.firstWhere(
                  (element) => element.weekNumber == currentWeekNumber,
              orElse: () => WeeklyKPI(weekNumber: 0, totalSales: 0.0, monthNumber: 0));

          AppNotifier.logWithScreen("KPI Dashboard Screen","CurrentWeek Matching To SelectedWeek: ${currentWeek.weekNumber}");
        } else {
          // filtered by week different with currentWeek
          currentWeek = weekly.firstWhere(
                  (element) => element.weekNumber == selectedWeek,
              orElse: () => WeeklyKPI(
                  weekNumber: selectedWeek!, totalSales: 0.0, monthNumber: 0));

          AppNotifier.logWithScreen("KPI Dashboard Screen","CurrentWeek Not Matching To SelectedWeek: ${currentWeek.weekNumber} ${currentWeek.totalSales}");
        }
      }
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: local.kpis,
        backBtn: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isTester? _buildUatProd() : const SizedBox.shrink(),
          MonthWeekFilter(
              selectedMonth: selectedMonth,
              selectedWeek: selectedWeek,
              weeksPerMonth: weeksPerMonth,
              onMonthChanged: _onMonthChanged,
              onWeekChanged: _onWeekChanged
          ),
          const SizedBox(height: 5),
          isLoading
              ? const Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return KpiPieChart(
                        title: local.dailyKpi,
                        achieved: daily,
                        target: monthlyTarget.toDouble(),
                        salesKpi: salesKpis,
                        currentWeek: currentWeek,
                        selectedMonth: selectedMonth,
                        selectedWeek: selectedWeek,
                        weeklyValues: weeklyValue,
                      );
                    case 1:
                      double achievedValue =
                      getAchievedValue(currentWeek, weekly);
                      return KpiPieChart(
                        title: local.weeklyKpi,
                        achieved: achievedValue,
                        target: monthlyTarget.toDouble(),
                        salesKpi: salesKpis,
                        currentWeek: currentWeek,
                        selectedMonth: selectedMonth,
                        selectedWeek: selectedWeek,
                        weeklyValues: weeklyValue,
                      );
                    case 2:
                      return KpiPieChart(
                        title: local.monthlyKpi,
                        achieved: monthly,
                        target: monthlyTarget.toDouble(),
                        salesKpi: salesKpis,
                        currentWeek: currentWeek,
                        selectedMonth: selectedMonth,
                        selectedWeek: selectedWeek,
                        weeklyValues: weeklyValue,
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUatProd(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isUAT ? Colors.green : Colors.orangeAccent,
          padding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        onPressed: () async {
          setState(() {
            isUAT = !isUAT;
          });
          await fetchKpis();
        },
        child: Text(
          isUAT ? 'UAT' : 'PROD',
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
