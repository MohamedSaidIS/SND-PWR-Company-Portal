import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String btnText;
  final void Function() btnFunction;
  final bool loading;

  const SubmitButton({
    super.key,
    required this.btnText,
    required this.btnFunction,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ElevatedButton(
      onPressed: loading ? null : btnFunction,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      child: loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              btnText,
              style: TextStyle(fontSize: 16, color: theme.colorScheme.surface),
            ),
    );
  }
}
