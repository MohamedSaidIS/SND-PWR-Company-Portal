import 'package:flutter/material.dart';
import 'package:company_portal/utils/export_import.dart';

Widget buildSectionTitle(String title, BuildContext context, ThemeData theme) {
  return Align(
    alignment: Alignment.center,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        title,
        style: theme.textTheme.labelLarge,
      ),
    ),
  );
}

Widget buildInfoCard(List<Widget> children, ThemeData theme) {
  return Card(
    color: theme.bottomSheetTheme.backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1 && children[i] is! Align)
              AppSeparators.infoDivider(theme),
          ]
        ],
      ),
    ),
  );
}

Widget buildInfoRow(
    String label, String value, IconData icon, ThemeData theme) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 8.0),
              child: Icon(
                icon,
                color: theme.colorScheme.secondary,
              ),
            ),
            Text(label, style: theme.textTheme.labelMedium),
          ],
        ),
      ),
      Expanded(
        flex: 3,
        child: Text(
          value,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    ],
  );
}
