import 'package:flutter/material.dart';

import '../utils/export_import.dart';

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

List<Map<String, String>> getDeviceType(AppLocalizations local) {
  return [
    {'value': 'Laptop', 'label': local.laptop},
    {'value': 'Desktop', 'label': local.desktop},
    {'value': 'NA', 'label': local.nA},
  ];
}

List<Map<String, String>> getIfNewEmailNeeded(AppLocalizations local) {
  return [
    {'value': 'Yes', 'label': local.yes},
    {'value': 'No', 'label': local.no},
    {'value': 'Current Email', 'label': local.currentEmail},
  ];
}

List<Map<String, String>> getYesNoList(AppLocalizations local) {
  return [
    {'value': 'Yes', 'label': local.yes},
    {'value': 'No', 'label': local.no},
  ];
}

List<Map<String, String>> getAppList(AppLocalizations local) {
  return [
    {'value': 'Ios', 'label': local.ios},
    {'value': 'Android', 'label': local.android},
    {'value': 'Web', 'label': local.web},
  ];
}

List<Map<String, String>> getTypeList(AppLocalizations local) {
  return [
    {'value': 'Issue', 'label': local.issue},
    {'value': 'Add', 'label': local.add},
  ];
}

List<Map<String, String>> getPurpose(AppLocalizations local) {
  return [
    {'value': 'CR Stander', 'label': local.crStander},
    {'value': 'CR Customize', 'label': local.crCustomize},
    {'value': 'BP Stander', 'label': local.bpStander},
    {'value': 'BP Customize', 'label': local.bpCustomize},
    {'value': 'Report', 'label': local.report},
  ];
}

List<Map<String, String>> getVacationCode(AppLocalizations local) {
  return [
    {'value': '001', 'label': local.sickLeave},
    {'value': 'سنوي-راتب', 'label': local.annualLeave},
  ];
}

List<Map<String, String>> getPermissionCode(AppLocalizations local) {
  return [
    {'value': 'إذن', 'label': local.permission},
    {'value': 'إذن مدفوع', 'label': local.paidPermission},
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
    case "delay":
      return Icons.more_time_rounded;
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
    case "delay":
      return Colors.brown;
    case "pending":
      return Colors.amber;
    default:
      return Colors.grey;
  }
}

String getTranslatedStatus(String status, AppLocalizations local) {
  switch (status.toLowerCase()) {
    case "new":
      return local.statusNew;
    case "in progress":
      return local.statusInProgress;
    case "completed":
      return local.statusCompleted;
    case "canceled":
      return local.statusCanceled;
    case "duplicate":
      return local.statusDuplicated;
    case "delay":
      return local.statusDelay;
    case "pending":
      return local.statusPending;
    default:
      return status;
  }
}

Color getPriorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case "critical":
      return Colors.red;
    case "high":
      return Colors.orange;
    case "low":
      return Colors.amber;
    case "normal":
      return Colors.green;
    default:
      return Colors.grey;
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

String getTranslatedPriorities(String priority, AppLocalizations local) {
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

IconData getApprovalIcon(String approve) {
  switch (approve.toLowerCase()) {
    case "yes":
      return Icons.check_circle;
    case "no":
      return Icons.cancel;
    default:
      return Icons.help_outline;
  }
}

Color getApprovalColor(String approve) {
  switch (approve.toLowerCase()) {
    case "yes":
      return Colors.green;
    case "no":
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String getTranslatedApproval(String approve, AppLocalizations local) {
  switch (approve.toLowerCase()) {
    case "yes":
      return local.approved;
    case "no":
      return local.notApproved;
    default:
      return local.statusPending;
  }
}

/////////////////////////////////////////////// Language ///////////////////////////////////////////////////

List<Map<String, String>> getLanguage(AppLocalizations local) {
  return [
    {"code": "en", "label": local.english},
    {"code": "ar", "label": local.arabic},
    {"code": "ur", "label": local.urdu},
  ];
}
