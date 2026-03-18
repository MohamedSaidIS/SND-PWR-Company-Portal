import 'package:flutter/material.dart';

import '../../../utils/export_import.dart';

class AllStaticData {
  static List<Map<String, String>> getNotificationSearch(AppLocalizations local) {
    return [
      {'value': 'all', 'label': local.all},
      {'value': 'update', 'label': 'Update'},
      {'value': 'reminder', 'label': 'Reminder'},
      {'value': 'vacation', 'label': 'Vacation'},
    ];
  }

  static IconData getNotificationIcon(String notification) {
    switch (notification.toLowerCase()) {
      case "reminder":
        return Icons.calendar_today;
      case "vacation":
        return Icons.beach_access;
      case "update":
        return Icons.update;
      default:
        return Icons.help_outline;
    }
  }

  static Color getNotificationIconColor(String notification){
    switch (notification.toLowerCase()) {
      case "reminder":
        return Colors.orange;
      case "vacation":
        return Colors.teal;
      case "update":
        return  Colors.orangeAccent;
      default:
        return Colors.blue;
    }
  }

  static Color? getNotificationBackgroundColor(String notification){
    switch (notification.toLowerCase()) {
      case "reminder":
        return Colors.yellow[100];
      case "vacation":
        return Colors.green[100];
      case "update":
        return  Colors.orange[50];
      default:
        return Colors.white;
    }
  }

  static List<Map<String, String>> getCategories(AppLocalizations local) {
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

  static List<Map<String, String>> getPriorities(AppLocalizations local) {
    return [
      {'value': 'Low', 'label': local.low},
      {'value': 'Normal', 'label': local.normal},
      {'value': 'High', 'label': local.high},
      {'value': 'Critical', 'label': local.critical},
    ];
  }

  static List<Map<String, String>> getDeviceType(AppLocalizations local) {
    return [
      {'value': 'Laptop', 'label': local.laptop},
      {'value': 'Desktop', 'label': local.desktop},
      {'value': 'NA', 'label': local.nA},
    ];
  }

  static List<Map<String, String>> getIfNewEmailNeeded(AppLocalizations local) {
    return [
      {'value': 'Yes', 'label': local.yes},
      {'value': 'No', 'label': local.no},
      {'value': 'Current Email', 'label': local.currentEmail},
    ];
  }

  static List<Map<String, String>> getYesNoList(AppLocalizations local) {
    return [
      {'value': 'Yes', 'label': local.yes},
      {'value': 'No', 'label': local.no},
    ];
  }

  static List<Map<String, String>> getAppList(AppLocalizations local) {
    return [
      {'value': 'Ios', 'label': local.ios},
      {'value': 'Android', 'label': local.android},
      {'value': 'Web', 'label': local.web},
    ];
  }

  static List<Map<String, String>> getTypeList(AppLocalizations local) {
    return [
      {'value': 'Issue', 'label': local.issue},
      {'value': 'Add', 'label': local.add},
    ];
  }

  static List<Map<String, String>> getPurpose(AppLocalizations local) {
    return [
      {'value': 'CR Stander', 'label': local.crStander},
      {'value': 'CR Customize', 'label': local.crCustomize},
      {'value': 'BP Stander', 'label': local.bpStander},
      {'value': 'BP Customize', 'label': local.bpCustomize},
      {'value': 'Report', 'label': local.report},
    ];
  }

  static List<Map<String, String>> getVacationCode(AppLocalizations local) {
    return [
      {'value': '001', 'label': local.sickLeave},
      {'value': 'سنوي-راتب', 'label': local.annualLeave},
    ];
  }

  static List<Map<String, String>> getPermissionCode(AppLocalizations local) {
    return [
      {'value': 'إذن', 'label': local.permission},
      {'value': 'إذن مدفوع', 'label': local.paidPermission},
    ];
  }

  static IconData getStatusIcon(String status) {
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

  static Color getStatusColor(String status) {
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

  static String getTranslatedStatus(String status, AppLocalizations local) {
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

  static Color getPriorityColor(String priority) {
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
  static IconData getPriorityIcon(String priority) {
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

  static String getTranslatedPriorities(String priority, AppLocalizations local) {
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

  static IconData getApprovalIcon(String approve) {
    switch (approve.toLowerCase()) {
      case "yes":
        return Icons.check_circle;
      case "no":
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  static Color getApprovalColor(String approve) {
    switch (approve.toLowerCase()) {
      case "yes":
        return Colors.green;
      case "no":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static String getTranslatedApproval(String approve, AppLocalizations local) {
    switch (approve.toLowerCase()) {
      case "yes":
        return local.approved;
      case "no":
        return local.notApproved;
      default:
        return local.statusPending;
    }
  }

  /// //////////////////////////////////////////// Language ///////////////////////////////////////////////////

  static List<Map<String, String>> getLanguage(AppLocalizations local) {
    return [
      {"code": "en", "label": local.english},
      {"code": "ar", "label": local.arabic},
      {"code": "ur", "label": local.urdu},
    ];
  }

  /// //////////////////////////////////////////// User Data ///////////////////////////////////////////////////

  static List<String> getTesterIds() {
    return [
      "9f212536-711a-49a0-ae93-a24e109f7473", //Eng.Amr
      "eaace885-1949-43ef-b957-d88a61c4bc47", //Eng.Hassan
      "b5bb877a-1361-4b8e-82fd-aa8e3ce45c25", //Eng.Mohamed
      "9f0a9906-7232-4ffe-ae9d-2c6c9697cc3a", //Eng.Hamad
      "e662e0d0-25d6-41a1-8bf3-55326a51cc16", //Eng.Amira
    ];
  }

  static List<String> getGroupsIds() {
    return [
      "1ea1d494-a377-4071-beac-301a99746d2a", //Information Systems Team
      "9876abcd-4321-aaaa-9999-bbbbbccccddd"
    ];
  }
}




