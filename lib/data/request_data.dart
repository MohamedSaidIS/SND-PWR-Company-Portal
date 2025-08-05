import 'package:company_portal/screens/request/vacation_request.dart';
import 'package:flutter/material.dart';

import '../screens/request/attend_leave_screen.dart';
import '../screens/request/permission_screen.dart';
import '../screens/request/vacation_balance_screen.dart';

class RequestItem {
  final IconData icon;
  final String label;
  final Widget navigatedScreen;

  const RequestItem({
    required this.icon,
    required this.label,
    required this.navigatedScreen,
  });
}

final List<RequestItem> requestItems = [
  const RequestItem(
      icon: Icons.access_time,
      label: 'Attend / Leave',
      navigatedScreen: AttendLeaveScreen()),
  const RequestItem(
      icon: Icons.flight_takeoff,
      label: 'Vacation \nRequest',
      navigatedScreen: VacationRequestScreen()),
  const RequestItem(
      icon: Icons.bar_chart,
      label: 'Vacation \nBalance',
      navigatedScreen: VacationBalanceScreen()),
  const RequestItem(
      icon: Icons.edit,
      label: 'Permission \nRequest',
      navigatedScreen: PermissionScreen()),
];
