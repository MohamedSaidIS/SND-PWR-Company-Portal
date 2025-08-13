import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

List<Map<String, String>> getCategories(AppLocalizations local) {
  return [
    {'value': 'IT', 'label': local.it},
    {'value': 'Marketing', 'label': local.marketing},
    {'value': 'Customer Service', 'label': local.customerService},
    {'value': 'HR', 'label': local.hr},
    {'value': 'Sales', 'label': local.sales},
    {'value': 'Finance', 'label': local.finance},
    {'value': 'Other', 'label': local.other},
  ];
}

List<Map<String, String>> getPriorities(AppLocalizations local) {
  return [
    {'value': 'Low', 'label': local.low},
    {'value': 'Normal', 'label': local.normal},
    {'value': 'High', 'label': local.high},
    {'value': 'Critical', 'label': local.critical},
  ];
}

final issues = [
  {"id": "101", "title": "Login not working", "status": "new"},
  {"id": "102", "title": "UI alignment issue", "status": "inprogress"},
  {"id": "103", "title": "Crash on iOS", "status": "completed"},
  {"id": "104", "title": "Feature request duplicated", "status": "duplicated"},
  {"id": "105", "title": "Wrong data in API", "status": "delay"},
  {"id": "106", "title": "User canceled request", "status": "canceled"},
];

IconData getStatusIcon(String status) {
  switch (status.toLowerCase()) {
    case "new":
      return Icons.fiber_manual_record;
    case "inprogress":
      return Icons.autorenew;
    case "completed":
      return Icons.check_circle;
    case "canceled":
      return Icons.cancel;
    case "duplicated":
      return Icons.copy;
    case "delay":
      return Icons.access_time;
    default:
      return Icons.help_outline;
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "new":
      return Colors.blue;
    case "inprogress":
      return Colors.orange;
    case "completed":
      return Colors.green;
    case "canceled":
      return Colors.red;
    case "duplicated":
      return Colors.purple;
    case "delay":
      return Colors.amber;
    default:
      return Colors.grey;
  }
}

String getTranslatedStatus(BuildContext context, String status, AppLocalizations local) {
  switch (status.toLowerCase()) {
    case "new":
      return local.statusNew;
    case "inprogress":
      return local.statusInProgress;
    case "completed":
      return local.statusCompleted;
    case "canceled":
      return local.statusCanceled;
    case "duplicated":
      return local.statusDuplicated;
    case "delay":
      return local.statusDelay;
    default:
      return status;
  }
}
