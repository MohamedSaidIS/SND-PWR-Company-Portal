import 'package:flutter/material.dart';
import '../../utils/export_import.dart';

class Section {
  final String? title;
  final String description;

  Section({
    this.title,
    required this.description,
  });

  static List<Section> getSectionsData(AppLocalizations local, BuildContext context) {
    return [
      Section(title: local.sectionTitleOne, description: local.sectionTextOne),
      Section(title: local.sectionTitleTwo, description: local.sectionTextTwo),
      Section(description: local.sectionTextTwoPartTwo),
      Section(title: local.sectionTitleThree, description: local.sectionTextThree),
      Section(description: local.sectionTextThreePartThree),
    ];
  }
}
