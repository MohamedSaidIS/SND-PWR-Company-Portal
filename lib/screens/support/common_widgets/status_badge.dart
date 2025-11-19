import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor(status);
    final icon = getStatusIcon(status);
    final local = context.local;
    final translatedValue = getTranslatedStatus(status, local).toUpperCase();

    return BadgeWidget(
        translatedTitle: translatedValue, color: color, icon: icon);
  }
}
