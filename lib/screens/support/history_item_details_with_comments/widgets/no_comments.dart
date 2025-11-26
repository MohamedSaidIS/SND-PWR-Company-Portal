import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';

class NoCommentsWidget extends StatelessWidget {
  const NoCommentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.colorScheme.primary.withValues(alpha:0.1),
            child: Icon(
              Icons.chat_bubble_outline,
              color: theme.colorScheme.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            local.noCommentsYet,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.primary.withValues(alpha:0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            local.beTheFirstToAddaComment,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.primary.withValues(alpha:0.6),
            ),
          ),
        ],
      ),
    );
  }
}
