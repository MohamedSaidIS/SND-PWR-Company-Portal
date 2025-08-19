import 'package:company_portal/models/section.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../screens/login/widgets/section_widget.dart';

List<Widget> getSections(AppLocalizations local, ThemeData theme,
    BuildContext context) {
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

  return sections.map((s) => SectionWidget(section: s, theme: theme, isArabic: isArabic)).toList();
}