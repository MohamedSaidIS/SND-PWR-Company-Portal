import 'package:flutter/material.dart';
import 'package:company_portal/utils/export_import.dart';
class NoKpiScreen extends StatelessWidget {
  const NoKpiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Scaffold(
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
                child: RepaintBoundary(
                  child: Image.asset(
                    "assets/images/no_kpi_found.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                local.youAreNotAMemberOfAnyGroupYet,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                local.reachOutToTheHRDepartmentIfYouNeedHelp,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha:0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
