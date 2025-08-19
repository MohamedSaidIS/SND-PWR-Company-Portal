import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/request_model.dart';
import '../screens/request/attend_leave_screen.dart';
import '../screens/request/permission_screen.dart';
import '../screens/request/vacation_balance_screen.dart';
import '../screens/request/vacation_request.dart';

List<RequestItem> getRequestItems(AppLocalizations local) {
  return [
    RequestItem(
        icon: Icons.access_time,
        label: local.attendLeaveRequest,
        navigatedScreen: const AttendLeaveScreen()),
    RequestItem(
        icon: Icons.flight_takeoff,
        label: local.vacationRequest,
        navigatedScreen: const VacationRequestScreen()),
    RequestItem(
        icon: Icons.bar_chart,
        label: local.vacationBalanceRequest,
        navigatedScreen: const VacationBalanceScreen()),
    RequestItem(
        icon: Icons.edit,
        label: local.permissionRequest,
        navigatedScreen: const PermissionScreen()),
  ];
}
