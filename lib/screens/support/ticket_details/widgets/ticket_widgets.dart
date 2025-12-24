import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class TicketSectionTitle extends StatelessWidget {
  final String text;
  const TicketSectionTitle({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Text(
      text,
      style: TextStyle(
        color: theme.colorScheme.secondary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class TicketHeader extends StatelessWidget {
  final String headerTitle, status;
  const TicketHeader({required this.headerTitle, required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Tooltip(
            message: TextHelper.capitalizeWords(headerTitle),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              TextHelper.capitalizeWords(headerTitle),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 19,
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        StatusBadge(status: status)
      ],
    );
  }
}

class TicketDescription extends StatelessWidget {
  final String description, priority;
  const TicketDescription({required this.description, required this.priority, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              local.description,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.primary,
                height: 1.4,
              ),
            ),
            PriorityBadge(priority: priority)
          ],
        ),
        const SizedBox(height: 6),
        Text(
          TextHelper.capitalize(description),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: theme.colorScheme.primary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class TicketDates extends StatelessWidget {
  final String createdDate, modifiedDate;
  const TicketDates({required this.createdDate, required this.modifiedDate, super.key});

  @override
  Widget build(BuildContext context) {
    final local = context.local;

    return Row(
      spacing: 30,
      children: [
        TimeWidget(
          icon: Icons.access_time,
          label: local.createdAt,
          value: createdDate,
        ),
        TimeWidget(
          icon: Icons.update,
          label: local.lastModified,
          value: modifiedDate.toString(),
        ),
      ],
    );
  }
}



