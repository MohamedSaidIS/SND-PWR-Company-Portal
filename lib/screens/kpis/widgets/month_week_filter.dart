import '../../../../utils/export_import.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MonthWeekFilter extends StatelessWidget {
  final int? selectedMonth;
  final int? selectedWeek;
  final List<int> weeksPerMonth;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<int> onWeekChanged;

  const MonthWeekFilter({
    super.key,
    required this.selectedMonth,
    required this.selectedWeek,
    required this.weeksPerMonth,
    required this.onMonthChanged,
    required this.onWeekChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final isArabic = context.isArabic();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: theme.colorScheme.primary.withValues(alpha:0.1),
          ),
          child: DropdownButton<int>(
            value: selectedMonth,
            underline: const SizedBox(),
            items: List.generate(12, (index) {
              final month = index + 1;
              return DropdownMenuItem(
                value: month,
                child: Text(isArabic
                    ? DateFormat.MMMM('ar').format(DateTime(0, month))
                    : DateFormat.MMMM().format(DateTime(0, month)),
                ),
              );
            }),
            onChanged: (val) {
              if (val != null) onMonthChanged(val);
            },
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: theme.colorScheme.primary.withValues(alpha:0.1),
          ),
          child: DropdownButton<int>(
            value:
                (selectedWeek != null && weeksPerMonth.contains(selectedWeek))
                    ? selectedWeek
                    : null,
            underline: const SizedBox(),
            items: weeksPerMonth.map((week) {
              return DropdownMenuItem(
                value: week,
                child: Text("${local.week} ${convertedToArabicNumber(week, isArabic)}"),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) onWeekChanged(val);
            },
          ),
        ),
      ],
    );
  }
}
