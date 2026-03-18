import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class StatusBadge extends StatefulWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge> {
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
    color = AllStaticData.getStatusColor(widget.status);
    icon = AllStaticData.getStatusIcon(widget.status);
    translatedValue = AllStaticData.getTranslatedStatus(widget.status, local).toUpperCase();

  }
  @override
  Widget build(BuildContext context) {
    return BadgeWidget(translatedTitle: translatedValue, color: color, icon: icon);
  }
}
