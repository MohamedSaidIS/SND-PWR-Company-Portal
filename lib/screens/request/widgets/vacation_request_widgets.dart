import 'package:flutter/material.dart';

import '../../../../utils/export_import.dart';

class VacationDates extends StatefulWidget {
  final VacationRequestController controller;

  const VacationDates({super.key, required this.controller});

  @override
  State<VacationDates> createState() => _VacationDatesState();
}

class _VacationDatesState extends State<VacationDates> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final alignment = context.alignment;
    final locale = context.currentLocale();

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              await widget.controller.pickDateTime(context, true);
              setState(() {});
            },
            style: outlineButtonStyle(
              theme,
              alignment,
            ),
            child: _buildDateText(
              local.startDate,
              widget.controller
                  .formatDate(widget.controller.startDate, local, locale),
              theme,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              await widget.controller.pickDateTime(context, false);
              setState(() {});
            },
            style: outlineButtonStyle(
              theme,
              alignment,
            ),
            child: _buildDateText(
              local.endDate,
              widget.controller
                  .formatDate(widget.controller.endDate, local, locale),
              theme,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget buildVacationDates() {}

ButtonStyle outlineButtonStyle(ThemeData theme, Alignment alignment,
    {Color? borderColor}) {
  return OutlinedButton.styleFrom(
    foregroundColor: theme.colorScheme.primary,
    alignment: alignment,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    side: BorderSide(
      color: borderColor ?? theme.colorScheme.secondary,
      width: 1,
    ),
  );
}

Widget _buildDateText(String dateText, String formatDate, ThemeData theme) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(dateText, style: theme.textTheme.titleMedium),
      const SizedBox(height: 3),
      Text(formatDate, style: theme.textTheme.titleSmall),
    ],
  );
}
