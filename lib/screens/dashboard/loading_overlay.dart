import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {

  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 20,
       color: Colors.transparent,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(theme.colorScheme.secondary),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                local.loadingData,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.surface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
