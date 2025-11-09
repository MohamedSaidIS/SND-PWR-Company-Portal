import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

void navigationScreen(BuildContext context, Widget navigatedScreen,) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return navigatedScreen;
      },
    ),
  );
}

Widget buildRequestCard(ThemeData theme, RequestItem item, bool isAnimated,
    bool isTablet, bool isLandScape) {
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