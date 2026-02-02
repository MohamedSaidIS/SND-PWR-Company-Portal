import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/export_import.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onDataLoaded;

  const DashboardScreen({required this.onDataLoaded, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  bool _isLoading = true;
  UserInfo? _userInfo;
  GroupInfo? _groupInfo;

  @override
  void initState() {
    super.initState();
    _bootStrap();
  }

  Future<void> _bootStrap() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) async{
        await _loadInitialData();
        if (!mounted) return;
        setState(() => _isLoading = false);
        widget.onDataLoaded?.call();
      });
    } catch (e, st) {
      AppLogger.error("Dashboard", "$e\n$st");
    }
  }

  Future<void> _loadInitialData() async {
    final userProvider = context.read<UserInfoProvider>();
    final imageProvider = context.read<UserImageProvider>();
    final managerProvider = context.read<ManagerInfoProvider>();
    final reportsProvider = context.read<DirectReportsProvider>();
    final vacationProvider = context.read<VacationBalanceProvider>();
    final allUsersProvider = context.read<AllOrganizationUsersProvider>();

    await Future.wait([
      userProvider.fetchUserInfo(),
      userProvider.getGroupId(),
      userProvider.getGroupMembers("4053f91a-d9a0-4a65-8057-1a816e498d0f"),
      imageProvider.fetchImage(),
      managerProvider.fetchManagerInfo(),
      allUsersProvider.getAllUsers(),
    ]);

    _userInfo = userProvider.userInfo;
    if (_userInfo == null) return;

    NotificationService.instance.init(_userInfo!.id);

    await vacationProvider.getWorkerPersonnelNumber(_userInfo!.id);
    await vacationProvider.getVacationTransactions(_userInfo!.id);

    if (reportsProvider.directReportList == null) {
      await reportsProvider.fetchRedirectReport();
    }

    await SharedPrefsHelper().saveUserData("UserId", _userInfo!.id);
    await SharedPrefsHelper().saveUserData("UserEmail", _userInfo!.mail ?? "");

    _groupInfo = userProvider.groupInfo;
    if (_groupInfo == null) return;

    await SharedPrefsHelper()
        .saveUserData("groupInfo", _groupInfo?.groupId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Stack(
          children: [
           const SharePointLauncherScreen(),
            if (_isLoading)
              const Align(
                alignment: Alignment.bottomCenter,
                child: LoadingOverlay(),
              ),
          ],
        ),
      ),
    );
  }
}
