import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ErrorStateWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LineAwesomeIcons.exclamation_circle_solid,
              size: 50, color: theme.colorScheme.secondary),
          const SizedBox(height: 15),
          Text("Error: $error", style: theme.textTheme.bodyLarge),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,

            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
              child: Text("Retry", style: TextStyle(fontSize: 15),),
            ),
          ),
        ],
      ),
    );
  }
}
