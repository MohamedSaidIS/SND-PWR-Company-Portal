import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/export_import.dart';

class TicketsHistory extends StatelessWidget {
  final String title;
  final String id;
  final bool needStatus;
  final String status;
  final Widget navigatedScreen;

  const TicketsHistory({
    required this.title,
    required this.id,
    required this.needStatus,
    required this.status,
    required this.navigatedScreen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return OpenContainer(
      closedElevation: 0,
      closedColor: Colors.transparent,
      openColor: theme.colorScheme.surface,
      transitionDuration: const Duration(milliseconds: 300),
      openBuilder: (context, _) => navigatedScreen,
      closedBuilder: (context, openContainer) => InkWell(
        onTap: openContainer,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                TextHelper.capitalize(title),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "${local.issueID}: $id",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
              trailing: needStatus
                  ? Transform.translate(
                      offset: const Offset(10, 0),
                      child: StatusBadge(status: status),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
