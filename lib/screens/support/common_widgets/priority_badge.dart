import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../data/support_forms_data.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;
  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = getPriorityColor(priority);
    final local = context.local;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(getPriorityIcon(priority), size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            getTranslatedPriorities(context, priority, local).toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
