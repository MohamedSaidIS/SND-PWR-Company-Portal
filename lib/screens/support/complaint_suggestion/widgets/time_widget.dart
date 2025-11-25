import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const TimeWidget(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  String formatDateTime(DateTime? dt, String locale) {
    if (dt == null) return "-";
    return DateFormat('MMM d, yyyy, hh:mm a', locale).format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.currentLocale();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        Text(
          formatDateTime(
              DateTime.parse(
                value,
              ),
              locale),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
