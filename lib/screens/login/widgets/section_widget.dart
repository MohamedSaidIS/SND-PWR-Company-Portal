import 'package:flutter/material.dart';
import '../../../models/section.dart';

class SectionWidget extends StatelessWidget {
  final Section section;
  final ThemeData theme;
  final bool isArabic;

  const SectionWidget({
    super.key,
    required this.section,
    required this.theme,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                section.title!,
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
            child: Text(
              section.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: isArabic ? theme.textTheme.bodyLarge?.fontSize : 15,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
