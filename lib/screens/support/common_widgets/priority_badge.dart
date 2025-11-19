import 'package:flutter/material.dart';

import '../../../utils/export_import.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = getPriorityColor(priority);
    final icon = getPriorityIcon(priority);
    final local = context.local;
    final translatedValue =
        getTranslatedPriorities(priority, local).toUpperCase();

    return BadgeWidget(
        translatedTitle: translatedValue, color: color, icon: icon);
  }
}
