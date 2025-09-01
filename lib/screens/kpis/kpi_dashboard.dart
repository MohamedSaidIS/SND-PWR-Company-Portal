import 'package:company_portal/screens/kpis/widgets/kpi_calculator.dart';
import 'package:company_portal/screens/kpis/widgets/pie_chart.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/custom_app_bar.dart';
import '../../providers/kpis_provider.dart';

class KpiScreen extends StatefulWidget {

  const KpiScreen({super.key,});

  @override
  State<KpiScreen> createState() => _KpiScreenState();
}

class _KpiScreenState extends State<KpiScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final salesKpiProvider = context.read<KPIProvider>();
      salesKpiProvider.getSalesKpi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final salesKpisProvider = context.watch<KPIProvider>();
    final salesKpis = salesKpisProvider.kpiList;
    final theme = context.theme;
    final local = context.local;

    final daily = KpiCalculator.calcDaily(salesKpis!);
    final weekly = KpiCalculator.calcWeekly(salesKpis);
    final monthly = KpiCalculator.calcMonthly(salesKpis);


    AppNotifier.printFunction("Daily", daily.toString());
    AppNotifier.printFunction("weekly", weekly.toString());
    AppNotifier.printFunction("Monthly", monthly.toString());

    final monthlyTarget = salesKpis.isNotEmpty ? salesKpis.last.monthlyTarget : 0;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: local.kpis,
        backBtn: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(1),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  achieved: weekly,
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
    );
  }
}

