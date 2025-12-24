import 'package:flutter/material.dart';

import '../../../utils/export_import.dart';

class PriorityBadge extends StatefulWidget {
  final String priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  State<PriorityBadge> createState() => _PriorityBadgeState();
}

class _PriorityBadgeState extends State<PriorityBadge> {

  late AppLocalizations local;
  late ThemeData theme;
  late Color color;
  late IconData icon;
  late String translatedValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = context.theme;
    local = context.local;
    color = getPriorityColor(widget.priority);
    icon = getPriorityIcon(widget.priority);
    translatedValue = getTranslatedPriorities(widget.priority, local).toUpperCase();

  }

  @override
  Widget build(BuildContext context) {
    // final color = getPriorityColor(widget.priority);
    // final icon = getPriorityIcon(widget.priority);
    // final local = context.local;
    // final translatedValue =
    //     getTranslatedPriorities(widget.priority, local).toUpperCase();

    return BadgeWidget(
        translatedTitle: translatedValue, color: color, icon: icon);
  }
}
