import 'package:flutter/material.dart';

import '../../../../utils/export_import.dart';

Widget buildVacationDates(
    VacationRequestController controller,
    ThemeData theme,
    AppLocalizations local,
    Alignment alignment,
    String locale,
    BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () => controller.pickDate(context, true),
          style: outlineButtonStyle(theme, alignment),
          child: _buildDateText(
            local.startDate,
            controller.formatDate(controller.startDate, local, locale),
            theme,
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: OutlinedButton(
          onPressed: () => controller.pickDate(context, false),
          style: outlineButtonStyle(theme, alignment),
          child: _buildDateText(
            local.endDate,
            controller.formatDate(controller.endDate, local, locale),
            theme,
          ),
        ),
      ),
    ],
  );
}

ButtonStyle outlineButtonStyle(ThemeData theme, Alignment alignment) {
  return OutlinedButton.styleFrom(
    foregroundColor: theme.colorScheme.primary,
    alignment: alignment,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
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
