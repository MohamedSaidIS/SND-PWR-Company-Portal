import 'package:company_portal/service/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../utils/export_import.dart';

Map<String, dynamic>? initialMessageData;

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onDataLoaded;

  const DashboardScreen({required this.onDataLoaded, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final WebViewController _controller;

  // final CookieManager cookieManager = CookieManager.instance();
  // final String sharepointUrl = "https://alsanidi.sharepoint.com";
  // late InAppWebViewController? webViewController;
  double webProgress = 0;
  String? accessToken;
  bool _isLoading = true;
  late final UserInfo userInfo;

  @override
  void initState() {
    super.initState();

    NotificationService.instance.init();
    // NotificationService.instance.notificationStream
    //     .listen((data) {
    //   debugPrint("📨 Stream data: $data");
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initialDataValues();

      if (mounted) {
        setState(() => _isLoading = false);
        AppLogger.info("Dashboard", "Calling onDataLoaded()");
        widget.onDataLoaded?.call();
      }

      // await _restoreCookies();

      await SecureStorageService().getData("SPAccessToken").then((value) {
        setState(() {
          AppLogger.info(
              "Dashboard Screen", "DashBoard Token: $value");
          accessToken = value.trim();
        });
      });
    });

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://alsanidi.sharepoint.com"));
  }

  void openSharePoint() async {
    final url = Uri.parse("https://alsanidi.sharepoint.com");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    }
  }

  Future<void> initialDataValues() async {
    try {
      final userProvider = context.read<UserInfoProvider>();
      final imageProvider = context.read<UserImageProvider>();
      final managerProvider = context.read<ManagerInfoProvider>();
      final directReportProvider = context.read<DirectReportsProvider>();
      final allUsersProvider = context.read<AllOrganizationUsersProvider>();
      final vacationBalanceProvider = context.read<VacationBalanceProvider>();

      await userProvider.fetchUserInfo();
      await userProvider.getGroupId();
      await userProvider
          .getGroupMembers("4053f91a-d9a0-4a65-8057-1a816e498d0f");
      await imageProvider.fetchImage();
      await managerProvider.fetchManagerInfo();
      await allUsersProvider.getAllUsers();

      if (directReportProvider.directReportList == null) {
        await directReportProvider.fetchRedirectReport();
      }

      userInfo = userProvider.userInfo!;
      await NotificationService.instance.registerUser(userInfo.id);

      final groupInfo = userProvider.groupInfo;

      if (groupInfo != null) {
        // ToDo: GetGroupMembers according to groupId   e662e0d0-25d6-41a1-8bf3-55326a51cc16
        AppLogger.info("Dashboard Screen",
            "✅ User Info Loaded: ${userInfo.id} |${userInfo.mail} | ${groupInfo.groupId}");
        await vacationBalanceProvider.getWorkerPersonnelNumber(userInfo.id);
        await vacationBalanceProvider.getVacationTransactions(userInfo.id);
        await SharedPrefsHelper().saveUserData("UserId", userInfo.id);
        await SharedPrefsHelper()
            .saveUserData("UserEmail", userInfo.mail ?? "");
        await SharedPrefsHelper().saveUserData("groupInfo", groupInfo.groupId);

        if (mounted) {
          AppLogger.info(
              "Dashboard", "All data loaded, calling onDataLoaded()");
          widget.onDataLoaded?.call();
        }
      } else {
        AppLogger.error(
            "Dashboard", "userInfo or groupInfo is null");
      }
    } catch (e, st) {
      AppLogger.error(
          "Dashboard", "❌ initialDataValues error: $e\n$st");
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
  void dispose() {
    // webViewController = null;
    super.dispose();
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
            SafeArea(
              child: Column(
                children: [
                  if (webProgress < 1)
                    LinearProgressIndicator(
                      value: webProgress,
                      color: theme.colorScheme.secondary,
                      backgroundColor: Colors.grey[300],
                      minHeight: 4,
                    ),
                  Expanded(
                      child: accessToken == null
                          ? AppNotifier.loadingWidget(theme)
                          : WebViewWidget(
                              controller: _controller,
                            )
                      // InAppWebView(
                      //   initialUrlRequest: URLRequest(
                      //     url: WebUri(sharepointUrl),
                      //   ),
                      //   initialSettings: InAppWebViewSettings(
                      //     javaScriptEnabled: true,
                      //     cacheEnabled: true,
                      //     clearCache: false,
                      //     domStorageEnabled: true,
                      //     sharedCookiesEnabled: true,
                      //     thirdPartyCookiesEnabled: true,
                      //     useHybridComposition: true,
                      //   ),
                      //   onWebViewCreated: (controller) {
                      //     webViewController = controller;
                      //   },
                      //   onLoadStop: (controller, url) async {
                      //     AppLogger.info(
                      //         "Dashboard Screen", "Finished loading: $url");
                      //     await _saveCookies();
                      //   },
                      //   onProgressChanged: (controller, progress) {
                      //     if (!mounted) return;
                      //     setState(() {
                      //       webProgress = progress / 100;
                      //     });
                      //   },
                      // ),
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
