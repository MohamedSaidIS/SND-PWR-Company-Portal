import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import '../../utils/export_import.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onDataLoaded;

  const DashboardScreen({required this.onDataLoaded, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final CookieManager cookieManager = CookieManager.instance();
  final String sharepointUrl = "https://alsanidi.sharepoint.com";
  late InAppWebViewController? webViewController;
  double webProgress = 0;
  String? accessToken;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    debugPrint("OnLoadedFun: ${widget.onDataLoaded}");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initialDataValues();
      if (mounted) {
        setState(() => _isLoading = false);
        AppNotifier.logWithScreen("Dashboard", "Calling onDataLoaded()");
        widget.onDataLoaded?.call();
      }

      await _restoreCookies();
    });
    SecureStorageService().getData("SPAccessToken").then((value) {
      setState(() {
        AppNotifier.logWithScreen(
            "Dashboard Screen", "DashBoard Token: $value");
        accessToken = value.trim();
      });
    });
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

      final userInfo = userProvider.userInfo;
      final groupInfo = userProvider.groupInfo;

      if (userInfo != null && groupInfo != null) {
        // ToDo: GetGroupMembers according to groupId   e662e0d0-25d6-41a1-8bf3-55326a51cc16
        AppNotifier.logWithScreen("Dashboard Screen",
            "✅ User Info Loaded: ${userInfo.id} ${groupInfo.groupId}");
        await vacationBalanceProvider.getWorkerPersonnelNumber(userInfo.id);
        await SharedPrefsHelper().saveUserData("UserId", userInfo.id);
        await SharedPrefsHelper().saveUserData("groupInfo", groupInfo.groupId);

        if (mounted) {
          AppNotifier.logWithScreen(
              "Dashboard", "✅ All data loaded, calling onDataLoaded()");
          widget.onDataLoaded?.call();
        }
      } else {
        AppNotifier.logWithScreen(
            "Dashboard", "⚠️ userInfo or groupInfo is null");
      }
    } catch (e, st) {
      AppNotifier.logWithScreen(
          "Dashboard", "❌ initialDataValues error: $e\n$st");
    }
  }

  Future<void> _restoreCookies() async {
    final cookiesJson = await SecureStorageService().getData("savedCookies");

    final cookiesList = jsonDecode(cookiesJson) as List;

    for (var c in cookiesList) {
      final value = c["value"];
      if (value != null && value.toString().isNotEmpty) {
        String domain = c["domain"];

        AppNotifier.logWithScreen("Dashboard Screen",
            "✅ Restored Cookie: ${c["name"]} =========== $value");

        if (c["name"] == "FedAuth" || c["name"] == "rtFa") {
          domain = ".sharepoint.com";
          AppNotifier.logWithScreen(
              "Dashboard Screen", "✅ Restored Cookie Domain: $domain");
        }

        await cookieManager.setCookie(
          url: WebUri(sharepointUrl),
          name: c["name"],
          value: value,
          domain: domain,
          path: c["path"] ?? "/",
          isSecure: c["isSecure"] ?? true,
          isHttpOnly: c["isHttpOnly"] ?? true,
        );
        AppNotifier.logWithScreen("Dashboard Screen",
            "Restored Cookie: ${c["name"]}=$value; domain=$domain");
      }
    }

    if (mounted) {
      await webViewController?.loadUrl(
        urlRequest: URLRequest(url: WebUri(sharepointUrl)),
      );
    }

    AppNotifier.logWithScreen(
        "Dashboard Screen", "✅ Cookies restored and WebView reloaded");
  }

  Future<void> _saveCookies() async {
    final cookies = await cookieManager.getCookies(url: WebUri(sharepointUrl));
    for (var c in cookies) {
      AppNotifier.logWithScreen("Dashboard Screen",
          "Restored Cookie: ${c.name}=${c.value}; domain=${c.domain}");
    }

    final cookiesList = cookies
        .map((c) => {
              "name": c.name,
              "value": c.value,
              "domain": c.domain,
              "path": c.path,
              "isSecure": c.isSecure,
              "isHttpOnly": c.isHttpOnly,
            })
        .toList();

    final cookiesJson = jsonEncode(cookiesList);

    await SecureStorageService().saveData("savedCookies", cookiesJson);

    AppNotifier.logWithScreen(
        "Dashboard Screen", "Cookies saved to storage: $cookiesJson");
  }

  @override
  void dispose() {
    webViewController = null;
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
                        ? const Center(child: CircularProgressIndicator())
                        : InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: WebUri(sharepointUrl),
                      ),
                      initialSettings: InAppWebViewSettings(
                        javaScriptEnabled: true,
                        cacheEnabled: true,
                        clearCache: false,
                        domStorageEnabled: true,
                        sharedCookiesEnabled: true,
                        thirdPartyCookiesEnabled: true,
                        useHybridComposition: true,
                      ),
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStop: (controller, url) async {
                        AppNotifier.logWithScreen(
                            "Dashboard Screen", "Finished loading: $url");
                        await _saveCookies();
                      },
                      onProgressChanged: (controller, progress) {
                        if (!mounted) return;
                        setState(() {
                          webProgress = progress / 100;
                        });
                      },
                    ),
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
