import 'package:company_portal/screens/dashboard/dashboard_screen.dart';
import 'package:company_portal/screens/apps/apps_screen.dart';
import 'package:company_portal/screens/kpis/kpi_dashboard.dart';
import 'package:company_portal/screens/request/requests_screen.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../account/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    final List screens = [
      const AppsScreen(),
      const DashboardScreen(),
      const KpiScreen(),
      const RequestsScreen(),
      const ProfileScreen(),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: SizedBox(
          child: NavigationBar(
            indicatorColor: theme.colorScheme.secondary,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            elevation: 50,
            surfaceTintColor: const Color(0xff3e3d3d),
            onDestinationSelected: (int newIndex) {
              setState(() {
                _currentIndex = newIndex;
              });
            },
            selectedIndex: _currentIndex,
            backgroundColor: theme.colorScheme.background,
            shadowColor: const Color(0xfc070707),
            destinations: [
              NavigationDestination(
                label: local.dashboard,
                icon: const Icon(LineAwesomeIcons.home_solid),
              ),
              NavigationDestination(
                label: local.apps,
                icon: const Icon(Icons.apps),
              ),
              NavigationDestination(
                label: local.kpis,
                icon: const Icon(LineAwesomeIcons.chart_bar),
              ),
              NavigationDestination(
                label: local.requests,
                icon: const Icon(LineAwesomeIcons.file_alt_solid),
              ),
              NavigationDestination(
                label: local.profile,
                icon: const Icon(LineAwesomeIcons.user),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
