import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String btnText;
  final void Function() btnFunction;

  const SubmitButton({
    super.key,
    required this.btnText,
    required this.btnFunction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ElevatedButton(
      onPressed: btnFunction,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      child: Text(
        btnText,
        style: TextStyle(fontSize: 16, color: theme.colorScheme.surface),
      ),
    );
  }
}
