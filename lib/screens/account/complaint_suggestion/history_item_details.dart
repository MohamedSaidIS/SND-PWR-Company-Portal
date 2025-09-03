import 'package:company_portal/common/custom_app_bar.dart';
import 'package:company_portal/screens/account/complaint_suggestion/widgets/modified_by_widget.dart';
import 'package:company_portal/screens/account/complaint_suggestion/widgets/priority_badge.dart';
import 'package:company_portal/screens/account/complaint_suggestion/widgets/status_badge.dart';
import 'package:company_portal/screens/account/complaint_suggestion/widgets/time_widget.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import '../../../models/remote/complaint_suggestion.dart';

class HistoryItemDetails extends StatelessWidget {
  final ComplaintSuggestion item;

  const HistoryItemDetails({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: local.issue_details,
        backBtn: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PriorityBadge(priority: item.fields?.priority ?? "-"),
                    const SizedBox(width: 2),
                    StatusBadge(status: item.fields?.status ?? "-"),
                  ],
                ),
              ),
              _titleWidget(
                item.fields?.title ?? "-",
                theme,
              ),
              const SizedBox(height: 12),
              _descriptionWidget(
                item.fields?.description ?? "-",
                theme,
              ),
              const SizedBox(height: 20),
              TimeWidget(
                icon: Icons.access_time,
                label: "Created At",
                value: item.createdDateTime.toString(),
              ),
              TimeWidget(
                icon: Icons.update,
                label: "Last Modified",
                value: item.lastModifiedDateTime.toString(),
              ),
              ModifiedByWidget(
                lastModifiedByName: item.lastModifiedBy?.user?.displayName,
                lastModifiedByEmail: item.lastModifiedBy?.user?.email,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _titleWidget(String title, ThemeData theme) {
  return  Text(
    title,
    style: TextStyle(
      fontSize: 19,
      color: theme.colorScheme.secondary,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _descriptionWidget(String description, ThemeData theme) {
  return Text(
    description,
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: theme.colorScheme.primary,
      height: 1.4,
    ),
  );
}
