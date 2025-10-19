import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModifiedByWidget extends StatelessWidget {
  final lastModifiedByName, lastModifiedByEmail;

  const ModifiedByWidget({super.key, this.lastModifiedByName, this.lastModifiedByEmail});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Divider(
            color: theme.colorScheme.secondary,
            thickness: 0.75,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Modified By",
        ),
        const SizedBox(height: 2),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor:
            theme.colorScheme.primary.withValues(alpha:0.2),
            child:
            Icon(Icons.person, color: theme.colorScheme.primary),
          ),
          title: Text(
            lastModifiedByName ?? "-",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          subtitle: Text(
            lastModifiedByEmail ?? "-",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
