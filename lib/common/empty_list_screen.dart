import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class EmptyListScreen extends StatelessWidget {
  const EmptyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Center(
      key: const ValueKey('emptyList'),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              child: Image.asset(
                "assets/images/empty_list.png",
                cacheHeight: 200,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              local.noItemsFound,
              style: theme.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Text(
            //   subtitle,
            //   style: theme.textTheme.displaySmall,
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }
}
