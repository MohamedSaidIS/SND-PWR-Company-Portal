import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String title;
  const EmptyScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          children: [
            Icon(
              Icons.not_interested_rounded,
              color: theme.colorScheme.secondary,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
