import 'package:company_portal/screens/kpis/widgets/kpi_calculator.dart';
import 'package:company_portal/screens/kpis/widgets/pie_chart.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchKpis());
  }

  Future<void> fetchKpis() async {
    final userId = await SharedPrefsHelper().getUserData("UserId");
    print("Fetching KPI for UserId: $userId, isUAT: $isUAT");

    final salesKpiProvider = context.read<KPIProvider>();
    await salesKpiProvider.getSalesKpi('{00000000-0000-0000-0000-000000000000}',
        isUAT: isUAT);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final salesKpisProvider = context.watch<KPIProvider>();
    final salesKpis = salesKpisProvider.kpiList;
    final isLoading = salesKpisProvider.loading;
    final theme = context.theme;
    final local = context.local;

    final daily = KpiCalculator.calculateDailySales(salesKpis!);
    final weekly = KpiCalculator.calculateWeeklySales(salesKpis);
    final monthly = KpiCalculator.calculateMonthlySales(salesKpis);

    //ToDo: get current week number Change it to DateTime.now()
    final currentWeekNumber = KpiCalculator.getWeekNumber(DateTime(2025, 4, 17));
    var currentWeek = WeeklyKPI(weekNumber: 0, totalSales: 0.0);
    if (weekly.isNotEmpty) {
       currentWeek = weekly
          .firstWhere((element) => element.weekNumber == currentWeekNumber);
    }

    AppNotifier.printFunction("Daily", daily.toString());
    AppNotifier.printFunction("weekly", weekly.toString());
    AppNotifier.printFunction("Monthly", monthly.toString());

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
                  print("ISUAT: $isUAT");
                });
                await fetchKpis();
              },
              child: Text(
                isUAT ? 'UAT' : 'PROD',
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
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
                              color: Colors.blue,
                            );
                          case 1:
                            return KpiPieChart(
                              title: "Weekly KPI",
                              achieved: currentWeek.totalSales,
                              target: monthlyTarget.toDouble(),
                              salesKpi: salesKpis,
                              color: Colors.green,
                            );
                          case 2:
                            return KpiPieChart(
                              title: "Monthly KPI",
                              achieved: monthly,
                              target: monthlyTarget.toDouble(),
                              salesKpi: salesKpis,
                              color: Colors.orange,
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
