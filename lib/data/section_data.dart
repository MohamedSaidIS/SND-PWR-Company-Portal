import 'package:flutter/material.dart';
import '../utils/export_import.dart';


List<Widget> getSections(AppLocalizations local, ThemeData theme,
    BuildContext context, double carouselHeight) {
  final isArabic = context.isArabic();

  final sections = [
    Section(
      title: local.sectionTitleOne,
      description: local.sectionTextOne,
    ),
    Section(
      title: local.sectionTitleTwo,
      description: local.sectionTextTwo,
    ),
    Section(
      description: local.sectionTextTwoPartTwo,
    ),
    Section(
      title: local.sectionTitleThree,
      description: local.sectionTextThree,
    ),
    Section(
      description: local.sectionTextThreePartThree,
    ),
  ];

  return sections.map((s) => SectionWidget(section: s, theme: theme, isArabic: isArabic, carouselHeight: carouselHeight,)).toList();
}