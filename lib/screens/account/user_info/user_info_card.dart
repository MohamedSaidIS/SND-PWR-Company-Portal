import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_separators.dart';

class UserInfoCard extends StatelessWidget {
  final List<Widget> children;

  const UserInfoCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Card(
      color: theme.bottomSheetTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1 && i != 0 )
                AppSeparators.infoDivider(theme),
            ]
          ],
        ),
      ),
    );
  }
}

class CardTitle extends StatelessWidget {
  final String title;

  const CardTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          title,
          style: theme.textTheme.labelLarge,
        ),
      ),
    );
  }
}


class CardInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const CardInfoRow({super.key, required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                child: Icon(
                  icon,
                  color: theme.colorScheme.secondary,
                ),
              ),
              Text(label, style: theme.textTheme.labelMedium),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}