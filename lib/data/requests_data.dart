import 'package:flutter/material.dart';

import '../utils/export_import.dart';

List<RequestItem> getRequestItems(AppLocalizations local) {
  return [
    // RequestItem(
    //     icon: Icons.access_time,
    //     label: local.attendLeaveRequest,
    //     navigatedScreen: const AttendLeaveScreen()),
    RequestItem(
        icon: Icons.flight_takeoff,
        label: local.requestsCreation,
        navigatedScreen: const VacationRequestScreen()),
    RequestItem(
        icon: Icons.bar_chart,
        label: local.vacationBalanceRequest,
        navigatedScreen: const VacationBalanceScreen()),
    // RequestItem(
    //     icon: Icons.edit,
    //     label: local.permissionRequest,
    //     navigatedScreen: const PermissionScreen()),
  ];
}
