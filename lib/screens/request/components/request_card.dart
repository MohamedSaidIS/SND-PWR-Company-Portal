import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../common/animations.dart';
import '../../../models/local/request_model.dart';

class RequestCard extends StatelessWidget {
  final RequestItem item;
  final bool isAnimated;
  const RequestCard({super.key, required this.item, required this.isAnimated});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isTablet = context.isTablet();
    final isLandScape = context.isLandScape();

    return ScaleAnimation(isAnimated: isAnimated, child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon,
                size: isTablet ? 90 : 60,
                color: theme.colorScheme.secondary),
            const SizedBox(height: 15),
            Text(
              item.label,
              style: TextStyle(
                fontSize: isTablet && isLandScape ? 22 : 15,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ),
    );
  }
}
