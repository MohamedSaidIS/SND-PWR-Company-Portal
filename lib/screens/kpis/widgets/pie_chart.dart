import 'dart:ui';

import 'package:company_portal/models/remote/sales_kpi.dart';
import 'package:company_portal/screens/kpis/kpis_details_screen.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


import '../../../utils/kpi_calculation_handler.dart';

class KpiPieChart extends StatelessWidget {
  final String title;
  final double achieved;
  final double target;
  final List<SalesKPI> salesKpi;
  final WeeklyKPI currentWeek;
  final int selectedMonth;
  final int? selectedWeek;

  const KpiPieChart({
    super.key,
    required this.title,
    required this.achieved,
    required this.target,
    required this.salesKpi,
    required this.currentWeek,
    required this.selectedMonth,
    required this.selectedWeek,
  });

  String getKpiValueDueDate() {
    if(title == "Daily KPI"){
      return KpiCalculationHandler.getLastDayName(salesKpi, selectedMonth, selectedWeek!);
    }else if(title == "Weekly KPI"){
      if(selectedWeek != null){
        return "Week: $selectedWeek";
      }else {
        DateTime lastDate = DateTime.now();
        if(salesKpi.isNotEmpty){
          lastDate = salesKpi.last.transDate;
        }
        return "Week: ${KpiCalculationHandler.getWeekNumber(lastDate)}";
      }
    }else{
      return KpiCalculationHandler.getMonthName(salesKpi, selectedMonth);
    }
  }

  Color getPieChartColor(num percent){
    if(percent >= 100){
      return Colors.green;
    }else if(percent >= 75){
      return Colors.orange;
    }else if(percent >= 50){
      return Colors.amberAccent;
    }else{
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final percent = (target == 0) ? 0 : (achieved  / target * 100);
    print("Week: $selectedWeek currentWeek: ${currentWeek.weekNumber}");

    //print("target $target achieved $achieved percent $percent");

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.primary.withOpacity(0.1),
      ),
      margin: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => KpisDetailsScreen(salesKpis: salesKpi, title: title, currentWeek: currentWeek, selectedMonth: selectedMonth,),
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
                        color: getPieChartColor(percent),
                        value: achieved,
                        title: '${percent.toStringAsFixed(2)}%',
                        radius: 55,
                        titleStyle:  TextStyle(
                          color: percent > 15?  Colors.white : Colors.black,
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
                "Achieved: ${achieved.toStringAsFixed(2)}",
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
