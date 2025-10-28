import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class ComplaintSuggestionOption extends StatelessWidget {
  final String text, groupValue, value;
  final void Function(String?) onChange;

  const ComplaintSuggestionOption(
      {super.key,
      required this.text,
      required this.groupValue,
      required this.value,
      required this.onChange,
      });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ListTile(
      onTap: () => onChange(value),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
      tileColor: groupValue == value
          ? theme.colorScheme.secondary.withValues(alpha:0.1)
          : theme.colorScheme.primary.withValues(alpha:0.1),
      leading: Radio<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChange,
        activeColor: theme.colorScheme.secondary,
      ),
      title: Transform.translate(
        offset: const Offset(-12, 0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.035,
          ),
        ),
      ),
    );
  }
}
