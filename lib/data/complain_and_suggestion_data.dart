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

IconData getStatusIcon(String status) {
  switch (status.toLowerCase()) {
    case "new":
      return Icons.fiber_manual_record;
    case "in progress":
      return Icons.autorenew;
    case "completed":
      return Icons.check_circle;
    case "canceled":
      return Icons.cancel;
    case "duplicate":
      return Icons.copy;
    case "pending":
      return Icons.access_time;
    default:
      return Icons.help_outline;
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "new":
      return Colors.blue;
    case "in progress":
      return Colors.orange;
    case "completed":
      return Colors.green;
    case "canceled":
      return Colors.red;
    case "duplicate":
      return Colors.purple;
    case "pending":
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

Color getPriorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case "critical":
      return Colors.red; // خطير جداً
    case "high":
      return Colors.orange; // عالي
    case "low":
      return Colors.amber; // منخفض
    case "normal":
      return Colors.green; // عادي
    default:
      return Colors.grey; // غير معروف
  }
}

/// Get priority icon
IconData getPriorityIcon(String priority) {
  switch (priority.toLowerCase()) {
    case "critical":
      return Icons.close;
    case "high":
      return Icons.arrow_upward;
    case "low":
      return Icons.arrow_downward;
    case "normal":
      return Icons.flag;
    default:
      return Icons.label_outline;
  }
}

String getTranslatedPriorities(BuildContext context, String priority, AppLocalizations local) {
  switch (priority.toLowerCase()) {
    case "critical":
      return local.critical;
    case "high":
      return local.high;
    case "normal":
      return local.normal;
    case "low":
      return local.low;
    default:
      return priority;
  }
}
