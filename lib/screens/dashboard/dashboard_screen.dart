import 'package:company_portal/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../utils/export_import.dart';


class DashboardScreen extends StatefulWidget {
  final VoidCallback? onDataLoaded;

  const DashboardScreen({required this.onDataLoaded, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final WebViewController _webController;

  double _progress = 0;
  bool _isLoading = true;
  String? _accessToken;
  UserInfo? _userInfo;
  GroupInfo? _groupInfo;

  static const _sharePointUrl = "https://alsanidi.sharepoint.com";

  @override
  void initState() {
    super.initState();
    _initWebView();
    _bootStrap();
  }

  void _initWebView(){
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (p){
              if(!mounted) return;
            setState(() => _progress = p / 100);
            },
            onWebResourceError: (error){
              AppLogger.error("WebView", error.description);
            },
          ),
        )
        ..loadRequest(Uri.parse(_sharePointUrl));
  }

  Future<void> _bootStrap() async{
    try{
      await _loadInitialData();
      await _loadToken();

      if(!mounted) return;
      setState(() => _isLoading = false);
      widget.onDataLoaded?.call();

    }catch (e, st) {
      AppLogger.error("Dashboard", "$e\n$st");
    }
  }

  Future<void> _loadToken() async{
    final token = await SecureStorageService().getData("SPAccessToken");
    if(!mounted) return;
    setState(()  => _accessToken = token.trim());
  }

  Future<void> _loadInitialData() async{
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
    if(_userInfo == null) return;

    NotificationService.instance.init(_userInfo!.id);

    await vacationProvider.getWorkerPersonnelNumber(_userInfo!.id);
    await vacationProvider.getVacationTransactions(_userInfo!.id);

    if(reportsProvider.directReportList == null){
      await reportsProvider.fetchRedirectReport();
    }

    await SharedPrefsHelper().saveUserData("UserId", _userInfo!.id);
    await SharedPrefsHelper().saveUserData("UserEmail", _userInfo!.mail ?? "");

    _groupInfo = userProvider.groupInfo;
    if(_groupInfo == null) return;

    await SharedPrefsHelper().saveUserData("groupInfo", _groupInfo?.groupId ?? "");

  }

  void _openInBrowser() async {
    final url = Uri.parse(_sharePointUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    }
  }

  // Future<void> _restoreCookies() async {
  //   final cookiesJson = await SecureStorageService().getData("savedCookies");
  //
  //   final cookiesList = jsonDecode(cookiesJson) as List;
  //
  //   for (var c in cookiesList) {
  //     final value = c["value"];
  //     if (value != null && value.toString().isNotEmpty) {
  //       String domain = c["domain"];
  //
  //       AppLogger.info("Dashboard Screen",
  //           "✅ Restored Cookie: ${c["name"]} =========== $value");
  //
  //       if (c["name"] == "FedAuth" || c["name"] == "rtFa") {
  //         domain = ".sharepoint.com";
  //         AppLogger.info(
  //             "Dashboard Screen", "✅ Restored Cookie Domain: $domain");
  //       }
  //
  //       await cookieManager.setCookie(
  //         url: WebUri(sharepointUrl),
  //         name: c["name"],
  //         value: value,
  //         domain: domain,
  //         path: c["path"] ?? "/",
  //         isSecure: c["isSecure"] ?? true,
  //         isHttpOnly: c["isHttpOnly"] ?? true,
  //       );
  //       AppLogger.info("Dashboard Screen",
  //           "Restored Cookie: ${c["name"]}=$value; domain=$domain");
  //     }
  //   }
  //
  //   if (mounted) {
  //     await webViewController?.loadUrl(
  //       urlRequest: URLRequest(url: WebUri(sharepointUrl)),
  //     );
  //   }
  //
  //   AppLogger.info(
  //       "Dashboard Screen", "✅ Cookies restored and WebView reloaded");
  // }
  //
  // Future<void> _saveCookies() async {
  //   final cookies = await cookieManager.getCookies(url: WebUri(sharepointUrl));
  //   for (var c in cookies) {
  //     AppLogger.info("Dashboard Screen",
  //         "Restored Cookie: ${c.name}=${c.value}; domain=${c.domain}");
  //   }
  //
  //   final cookiesList = cookies
  //       .map((c) => {
  //             "name": c.name,
  //             "value": c.value,
  //             "domain": c.domain,
  //             "path": c.path,
  //             "isSecure": c.isSecure,
  //             "isHttpOnly": c.isHttpOnly,
  //           })
  //       .toList();
  //
  //   final cookiesJson = jsonEncode(cookiesList);
  //
  //   await SecureStorageService().saveData("savedCookies", cookiesJson);
  //
  //   AppLogger.info(
  //       "Dashboard Screen", "Cookies saved to storage: $cookiesJson");
  // }


  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  if (_progress < 1)
                    LinearProgressIndicator(
                      value: _progress,
                      color: theme.colorScheme.secondary,
                      backgroundColor: Colors.grey[300],
                      minHeight: 4,
                    ),
                  Expanded(
                      child: _accessToken == null
                          ? AppNotifier.loadingWidget(theme)
                          : WebViewWidget(
                              controller: _webController,
                            )
                      ),
                ],
              ),
            ),
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
