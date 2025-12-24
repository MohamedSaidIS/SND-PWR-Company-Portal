import 'package:flutter/material.dart';
import '../../utils/export_import.dart';

class LoadingOverlay extends StatelessWidget {

  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 25,
       color: Colors.transparent,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: AppNotifier.loadingWidget(theme)
              ),
              const SizedBox(width: 16),
              Text(
                local.loadingData,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.secondary,
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
