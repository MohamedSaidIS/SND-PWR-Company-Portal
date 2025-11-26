import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../utils/export_import.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isUserDataLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = context.read<UserInfoProvider>();
      userProvider.getGroupId();
    });
  }

  Widget getKpiScreen(GroupInfo? userGroupIds) {
    AppNotifier.logWithScreen(
        "Home Screen", "$userGroupIds, ${userGroupIds?.groupId}");
    if (userGroupIds == null) {
      return const NoKpiScreen();
    }

    switch (userGroupIds.groupId) {
      case "1ea1d494-a377-4071-beac-301a99746d2a": // Management
        return const ManagementKpiScreen();
      case "4053f91a-d9a0-4a65-8057-1a816e498d0f": // Sales
        return const SalesKpiScreen();
      // case "9876abcd-4321-aaaa-9999-bbbbb1111ddd": // Sales
      //   return const SalesKpiScreen();
      // case "9876abcd-4321-aaaa-9999-bbbbbcc11ddd": // Sales
      //   return const SalesKpiScreen();
      default:
        return const SalesKpiScreen();
    }
  }

  void _onDataLoaded() {
    setState(() {
      _isUserDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = context.watch<UserInfoProvider>();
    final groupId = userInfoProvider.groupInfo;
    final theme = context.theme;
    final local = context.local;

    final List screens = [
      DashboardScreen(onDataLoaded: _onDataLoaded),
      const AppsScreen(),
      getKpiScreen(groupId),
      const RequestsScreen(),
      const ProfileScreen(),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
          body: screens[_currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
              height: 60,
              index: _currentIndex,
              letIndexChange: (newIndex) {
                if (!_isUserDataLoaded && newIndex != 0) {
                  AppNotifier.snackBar(
                    context,
                    local.loadingData,
                    SnackBarType.warning,
                  );
                  return false;
                }
                return true;
              },
              onTap: (index) async {
                setState(() => _currentIndex = index);
                if (index == 2) {
                  final userProvider = context.read<UserInfoProvider>();
                  await userProvider.getGroupId();
                }

              },
              backgroundColor: _currentIndex ==0? theme.navigationBarTheme.shadowColor! : Colors.transparent,
              buttonBackgroundColor: theme.colorScheme.secondary,
              color: theme.navigationBarTheme.backgroundColor!,
              items: const [
                Icon(LineAwesomeIcons.home_solid, size: 30),
                Icon(Icons.apps, size: 30),
                Icon(LineAwesomeIcons.chart_bar, size: 30),
                Icon(LineAwesomeIcons.file_alt_solid, size: 30),
                Icon(LineAwesomeIcons.user, size: 30),
              ])
          // SizedBox(
          //   child: NavigationBar(
          //     indicatorColor: theme.colorScheme.secondary,
          //     labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          //     elevation: 50,
          //     surfaceTintColor: const Color(0xff3e3d3d),
          //     onDestinationSelected: (int newIndex) async{
          //       if(!_isUserDataLoaded && newIndex != 0){
          //         AppNotifier.snackBar(context, "جاري تحميل بيانات المستخدم...", SnackBarType.warning);
          //         return;
          //       }
          //       setState(() {
          //         _currentIndex = newIndex;
          //       });
          //       if (newIndex == 2) {
          //         final userProvider = context.read<UserInfoProvider>();
          //         await userProvider.getGroupId();
          //       }
          //     },
          //     selectedIndex: _currentIndex,
          //     backgroundColor: theme.colorScheme.surface,
          //     shadowColor: const Color(0xfc070707),
          //     labelTextStyle: const WidgetStatePropertyAll(
          //       TextStyle(
          //         fontSize: 11,
          //         fontWeight: FontWeight.w600,
          //         color: Colors.black,
          //       ),
          //     ),
          //     destinations: [
          //       NavigationDestination(
          //         label: local.dashboard,
          //         icon: const Icon(LineAwesomeIcons.home_solid),
          //       ),
          //       NavigationDestination(
          //         label: local.apps,
          //         icon: const Icon(Icons.apps),
          //       ),
          //       NavigationDestination(
          //         label: local.kpis,
          //         icon: const Icon(LineAwesomeIcons.chart_bar),
          //       ),
          //       NavigationDestination(
          //         label: local.requests,
          //         icon: const Icon(LineAwesomeIcons.file_alt_solid),
          //       ),
          //       NavigationDestination(
          //         label: local.profile,
          //         icon: const Icon(LineAwesomeIcons.user),
          //       ),
          //     ],
          //   ),
          // ),
          ),
    );
  }
}
