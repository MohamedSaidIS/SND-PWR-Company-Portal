import 'package:flutter/material.dart';
import '../../../utils/export_import.dart';

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
    final isLandScape = context.isLandScape();
    final screenWidth = MediaQuery.of(context).size.width;


    return SizedBox(
      height: carouselHeight,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (section.title != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21,vertical: 2),
                child: Text(
                  section.title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: isLandScape ? (carouselHeight * 0.1) : (screenWidth * 0.05),
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21.0),
              child: Text(
                section.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: isLandScape ? (carouselHeight * 0.1) : (carouselHeight * 0.035),
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
