import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../common/custom_app_bar.dart';

class NoKpiScreen extends StatelessWidget {
  const NoKpiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: local.kpis,
        backBtn: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 180,
                child: Image.asset(
                  "assets/images/no_kpi_found.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "You are not involved in any group",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Contact with HR Department to help you.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
