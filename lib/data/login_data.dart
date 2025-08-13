import 'package:company_portal/l10n/app_localizations.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

List<Widget> getItems(AppLocalizations local, ThemeData theme, BuildContext context) {
  final isArabic = context.isArabic();

  return [
    SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15,),
          sectionTitle(local.sectionTitleOne, theme, isArabic),
          const SizedBox(height: 10,),
          sectionText(local.sectionTextOne, theme, isArabic),
        ],
      ),
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15,),
        sectionTitle(local.sectionTitleTwo, theme, isArabic),
        const SizedBox(height: 10,),
        sectionText(local.sectionTextTwo, theme, isArabic),
      ],
    ),
    SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40,),
          sectionText(local.sectionTextTwoPartTwo, theme, isArabic),
        ],
      ),
    ),
    SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15,),
          sectionTitle(local.sectionTitleThree, theme, isArabic),
          const SizedBox(height: 10,),
          sectionText(local.sectionTextThree, theme, isArabic),
        ],
      ),
    ),
    SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40,),
          sectionText(local.sectionTextThreePartThree, theme, isArabic),
        ],
      ),
    ),
  ];
}


Widget sectionTitle(String title, ThemeData theme, bool isArabic,) {
  return Padding(
    padding:  EdgeInsets.only(top: 20, bottom: 6,  left: isArabic? 0 : 25, right: isArabic ? 25: 0),
    child: Text(
      title,
      style: theme.textTheme.titleLarge!.copyWith(fontSize: 20),
      textAlign: TextAlign.left,
    ),
  );
}

Widget sectionText(String text, ThemeData theme, bool isArabic) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Text(
      text,
      style: isArabic? theme.textTheme.bodyLarge : theme.textTheme.bodyLarge!.copyWith(fontSize: 15),

    ),
  );
}