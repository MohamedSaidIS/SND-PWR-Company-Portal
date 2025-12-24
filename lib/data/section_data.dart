import 'package:flutter/material.dart';
import '../utils/export_import.dart';

List<Section> getSectionsData(AppLocalizations local, BuildContext context) {
  return [
    Section(title: local.sectionTitleOne, description: local.sectionTextOne),
    Section(title: local.sectionTitleTwo, description: local.sectionTextTwo),
    Section(description: local.sectionTextTwoPartTwo),
    Section(title: local.sectionTitleThree, description: local.sectionTextThree),
    Section(description: local.sectionTextThreePartThree),
  ];
}

// List<Widget> getSections(AppLocalizations local, ThemeData theme, BuildContext context, double carouselHeight) {
//   late final List<Widget> _sectionWidgets;
//   final isEnglish = context.isEnglish();
//
//   final sections = [
//     Section(
//       title: local.sectionTitleOne,
//       description: local.sectionTextOne,
//     ),
//     Section(
//       title: local.sectionTitleTwo,
//       description: local.sectionTextTwo,
//     ),
//     Section(
//       description: local.sectionTextTwoPartTwo,
//     ),
//     Section(
//       title: local.sectionTitleThree,
//       description: local.sectionTextThree,
//     ),
//     Section(
//       description: local.sectionTextThreePartThree,
//     ),
//   ];
//   _sectionWidgets = sections.map((s) => SectionWidget(
//     key: ValueKey(s.title ?? s.description),
//     section: s,
//     theme: theme,
//     isEnglish: isEnglish,
//     carouselHeight: carouselHeight,
//   )).toList();
//
//   return _sectionWidgets;
//  // return sections.map((s) => SectionWidget(key: ValueKey(s.title ?? s.description), section: s, theme: theme, isEnglish: isEnglish, carouselHeight: carouselHeight,)).toList();
// }