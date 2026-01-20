import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KpiEvaluationYears extends StatefulWidget {
  final List<KPISheet> kpiSheets;
  final String userEmail;

  const KpiEvaluationYears(
      {super.key, required this.kpiSheets, required this.userEmail});

  @override
  State<KpiEvaluationYears> createState() => _KpiEvaluationYearsState();
}

class _KpiEvaluationYearsState extends State<KpiEvaluationYears> {
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     context.read<ManagementKpiProvider>();
    });
  }

  @override
  Widget build(BuildContext context) {
    final kpiProvider = context.watch<ManagementKpiProvider>();

    if (selectedFilter == null && widget.kpiSheets.isNotEmpty) {
      final item = widget.kpiSheets[0];
      selectedFilter = "${item.year.toString()}_${item.quarter}";
      //"${DateTime.now().year}_${widget.kpiSheets.first.quarter}";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        kpiProvider.getKpiSheet(widget.userEmail, item.year, item.quarter);
      });
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: widget.kpiSheets.map((item) {
          return YearFilterButton(
            text: "${item.year.toString()}_${item.quarter}",
            selected:
                selectedFilter == "${item.year.toString()}_${item.quarter}",
            onPressed: () async {
              setState(() {
                selectedFilter = "${item.year.toString()}_${item.quarter}";
              });
              Future.microtask(() {
                kpiProvider.getKpiSheet(
                    widget.userEmail /*"Sm@alsanidi.com.sa"*/,
                    item.year,
                    item.quarter);
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

class YearFilterButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onPressed;

  const YearFilterButton({
    super.key,
    required this.text,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selected ? theme.colorScheme.secondary : Colors.white,
          foregroundColor: selected ? Colors.white : Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
