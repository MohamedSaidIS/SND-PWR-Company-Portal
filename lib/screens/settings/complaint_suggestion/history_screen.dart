import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import '../../../data/complain_and_suggestion_data.dart';
import '../../../l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: issues.length,
        itemBuilder: (context, index) {
          final issue = issues[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(
                issue["title"]!,
                style: const TextStyle(fontSize : 15, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text("${local.issueID}: ${issue["id"]!}",
                  style: TextStyle(fontSize : 15, fontWeight: FontWeight.w500, color: theme.colorScheme.secondary),
                ),
              ),
              trailing: buildStatusBadge(context, issue["status"]!,local),
            ),
          );
        },
      ),
    );
  }
}

Widget buildStatusBadge(BuildContext context, String status, AppLocalizations local) {
  final color = getStatusColor(status);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(getStatusIcon(status), size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          getTranslatedStatus(context, status, local).toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
