import 'package:company_portal/utils/kpi_calculation_handler.dart';
import 'package:company_portal/screens/kpis/widgets/pie_chart.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../common/custom_app_bar.dart';
import '../../providers/kpis_provider.dart';
import '../../service/sharedpref_service.dart';

class KpiScreen extends StatefulWidget {
  const KpiScreen({
    super.key,
  });

  @override
  State<KpiScreen> createState() => _KpiScreenState();
}

class _KpiScreenState extends State<KpiScreen> {
  bool isUAT = true;
  bool isLoading = false;

  int selectedMonth = DateTime.now().month;
  int? selectedWeek;
  late List<int> weeksPerMonth;

  @override
  void initState() {
    super.initState();
    _rebuildWeeks();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchKpis());
  }

  Future<void> fetchKpis() async {
    final userId = await SharedPrefsHelper().getUserData("UserId");
    print("Fetching KPI for UserId: $userId, isUAT: $isUAT");

    final salesKpiProvider = context.read<KPIProvider>();
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

  @override
  Widget build(BuildContext context) {
    final salesKpisProvider = context.watch<KPIProvider>();
    final salesKpis = salesKpisProvider.kpiList;

    if(salesKpis!.isNotEmpty){
      print("SalesKpis: ${salesKpis[0].lastSalesAmount} ");
    }

    final isLoading = salesKpisProvider.loading;
    final theme = context.theme;
    final local = context.local;

    final daily = KpiCalculationHandler.calculateDailySales(salesKpis, selectedMonth, selectedWeek!);
    final weekly = KpiCalculationHandler.calculateWeeklySales(salesKpis, selectedMonth);
    final monthly = KpiCalculationHandler.calculateMonthlySales(salesKpis, selectedMonth);

    // AppNotifier.printFunction("Daily", daily.toString());
    // AppNotifier.printFunction("Monthly", monthly.toString());
    //
    final currentWeekNumber =
        KpiCalculationHandler.getWeekNumber(DateTime.now());
    var currentWeek = WeeklyKPI(weekNumber: 0, totalSales: 0.0, monthNumber: 0);

    if (weekly.isNotEmpty) {
      for(var i in weekly){
        print("weekly: ${i.weekNumber}");
      }

      if(currentWeekNumber == selectedWeek ){
        currentWeek = weekly.firstWhere(
                (element) => element.weekNumber == currentWeekNumber,
            orElse: () => WeeklyKPI(weekNumber: 0, totalSales: 0.0, monthNumber: 0));
        AppNotifier.printFunction("weekly", weekly.first.weekNumber.toString());
        print("CurrentWeek1: ${currentWeek.weekNumber}");
      }else{
        currentWeek = weekly.firstWhere(
                (element) => element.weekNumber == selectedWeek,
            orElse: () => WeeklyKPI(weekNumber: selectedWeek!, totalSales: 0.0, monthNumber: 0));

        print("CurrentWeek2: ${currentWeek.weekNumber} ${currentWeek.totalSales}");
      }

    }



    final monthlyTarget =
        salesKpis.isNotEmpty ? salesKpis.last.monthlyTarget : 0;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: local.kpis,
        backBtn: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
                child: DropdownButton<int>(
                  value: selectedMonth,
                  underline: const SizedBox(),
                  items: List.generate(12, (index) {
                    final month = index + 1;
                    return DropdownMenuItem(
                      value: month,
                      child: Text(DateFormat.MMMM().format(DateTime(0, month))),
                    );
                  }),
                  onChanged: (val) {
                    if (val != null) _onMonthChanged(val);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
                child: DropdownButton<int>(
                  value: (selectedWeek != null &&
                          weeksPerMonth.contains(selectedWeek))
                      ? selectedWeek
                      : null,
                  underline: const SizedBox(),
                  items: weeksPerMonth.map((week) {
                    return DropdownMenuItem(
                      value: week,
                      child: Text("Week $week"),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedWeek = val;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          isLoading
              ? const Center(child: CircularProgressIndicator())
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
                              title: "Daily KPI",
                              achieved: daily,
                              target: monthlyTarget.toDouble(),
                              salesKpi: salesKpis,
                              currentWeek: currentWeek,
                              selectedMonth: selectedMonth,
                              selectedWeek: selectedWeek,
                            );
                          case 1:
                            double achievedValue;
                            if (currentWeek.weekNumber != 0) {
                              if (currentWeek.totalSales == 0.0) {
                                achievedValue = 0.0;
                              } else {
                                achievedValue = currentWeek.totalSales;
                              }
                            } else {
                              achievedValue = weekly.isNotEmpty ? weekly.last.totalSales : 0.0;
                            }
                            return KpiPieChart(
                              title: "Weekly KPI",
                              achieved: achievedValue,
                              target: monthlyTarget.toDouble(),
                              salesKpi: salesKpis,
                              currentWeek: currentWeek,
                              selectedMonth: selectedMonth,
                              selectedWeek: selectedWeek ,
                            );
                          case 2:
                            return KpiPieChart(
                              title: "Monthly KPI",
                              achieved: monthly,
                              target: monthlyTarget.toDouble(),
                              salesKpi: salesKpis,
                              currentWeek: currentWeek,
                              selectedMonth: selectedMonth,
                              selectedWeek: selectedWeek,
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
}
