import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../models/local/section.dart';

class SectionWidget extends StatelessWidget {
  final Section section;
  final ThemeData theme;
  final bool isArabic;
  final double carouselHeight;

  const SectionWidget({
    super.key,
    required this.section,
    required this.theme,
    required this.isArabic,
    required this.carouselHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: carouselHeight,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (section.title != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  section.title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
              child: Text(
                section.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: carouselHeight * 0.035,
                ),
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
