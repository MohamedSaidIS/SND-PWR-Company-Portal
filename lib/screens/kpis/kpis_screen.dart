import 'package:company_portal/utils/context_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class KpisScreen extends StatefulWidget {
  const KpisScreen({super.key});

  @override
  State<KpisScreen> createState() => _KpisScreenState();
}

class _KpisScreenState extends State<KpisScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;


    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: theme.appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          title: Text(local.kpis,
              style: theme.textTheme.headlineLarge,
          ),
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
              // Bar Chart
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 20,
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(toY: 8, color: Colors.orange,borderRadius: BorderRadius.zero, width: 10),
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 12, color: Colors.green, borderRadius: BorderRadius.zero, width: 10),
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(toY: 6, color: Colors.red, borderRadius: BorderRadius.zero, width: 10),
                      ]),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text("Mon");
                              case 1:
                                return const Text("Tue");
                              case 2:
                                return const Text("Wed");
                              default:
                                return const Text("");
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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

  const KPIBox({super.key, required this.title, required this.value, required this.color});

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
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
