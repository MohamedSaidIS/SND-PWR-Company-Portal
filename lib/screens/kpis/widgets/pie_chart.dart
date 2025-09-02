import 'dart:ui';

import 'package:company_portal/models/sales_kpi.dart';
import 'package:company_portal/screens/kpis/kpis_details_screen.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'kpi_calculator.dart';

class KpiPieChart extends StatelessWidget {
  final String title;
  final double achieved;
  final double target;
  final List<SalesKPI> salesKpi;
  final Color color;

  const KpiPieChart({
    super.key,
    required this.title,
    required this.achieved,
    required this.target,
    required this.salesKpi,
    required this.color,
  });

  String getKpiValueDueDate() {
    if(title == "Daily KPI"){
      return KpiCalculator.getLastDayName(salesKpi);
    }else if(title == "Weekly KPI"){
      return "Week: ${KpiCalculator.getWeekNumber(salesKpi.last.transDate)}";
    }else{
      return KpiCalculator.getMonthName(salesKpi);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final percent = (target == 0) ? 0 : (achieved / target * 100);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.primary.withOpacity(0.1),
      ),
      margin: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => KpisDetailsScreen(salesKpis: salesKpi, title: title,),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 0,
                    sections: [
                      PieChartSectionData(
                        color: color,
                        value: achieved,
                        title: '${percent.toStringAsFixed(2)}%',
                        radius: 55,
                        titleStyle:  TextStyle(
                          color: percent > 10?  Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.white.withOpacity(0.6),
                        value: (target - achieved).clamp(0, target),
                        title: '',
                        radius: 45,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                getKpiValueDueDate(),
                style:
                     TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.colorScheme.secondary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                "Achieved: $achieved",
                style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
