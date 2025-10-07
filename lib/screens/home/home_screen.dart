
import 'package:company_portal/models/remote/group_info.dart';
import 'package:company_portal/screens/dashboard/dashboard_screen.dart';
import 'package:company_portal/screens/apps/apps_screen.dart';
import 'package:company_portal/screens/kpis/no_kpi_screen.dart';
import 'package:company_portal/screens/kpis/sales_kpi_dashboard.dart';
import 'package:company_portal/screens/kpis/managment_kpi_dashboard.dart';
import 'package:company_portal/screens/request/requests_screen.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/user_info_provider.dart';
import '../account/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) async {
       final userProvider = context.read<UserInfoProvider>();
       userProvider.getGroupId();
     });
  }

  Widget getKpiScreen(GroupInfo? userGroupIds) {
    AppNotifier.logWithScreen("Home Screen", "$userGroupIds, ${userGroupIds?.groupId}");
    if (userGroupIds == null) {
      return const NoKpiScreen();
    }

    switch (userGroupIds.groupId) {
      case "1ea1d494-a377-4071-beac-301a99746d2a": // Management
        return const ManagementKpiScreen();
      case "9876abcd-4321-aaaa-9999-bbbbbccccddd": // Sales
        return const SalesKpiScreen();
      case "9876abcd-4321-aaaa-9999-bbbbb1111ddd": // Sales
        return const SalesKpiScreen();
      case "9876abcd-4321-aaaa-9999-bbbbbcc11ddd": // Sales
        return const SalesKpiScreen();
      default:
        return const NoKpiScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = context.watch<UserInfoProvider>();
    final groupId = userInfoProvider.groupInfo;
    final theme = context.theme;
    final local = context.local;


    final List screens = [
      const DashboardScreen(),
      const AppsScreen(),
      getKpiScreen(groupId),
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
            onDestinationSelected: (int newIndex) async{
              setState(() {
                _currentIndex = newIndex;
              });
              if (newIndex == 2) {
                final userProvider = context.read<UserInfoProvider>();
                await userProvider.getGroupId();
              }
            },
            selectedIndex: _currentIndex,
            backgroundColor: theme.colorScheme.surface,
            shadowColor: const Color(0xfc070707),
            labelTextStyle: const WidgetStatePropertyAll(
              TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
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
