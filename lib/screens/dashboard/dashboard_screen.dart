import 'dart:convert';

import 'package:company_portal/service/sharedpref_service.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../../providers/all_organization_users_provider.dart';
import '../../providers/direct_reports_provider.dart';
import '../../providers/manager_info_provider.dart';
import '../../providers/user_image_provider.dart';
import '../../providers/user_info_provider.dart';
import '../../service/secure_storage_service.dart';
import '../../utils/app_notifier.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final CookieManager cookieManager = CookieManager.instance();
  final String sharepointUrl = "https://alsanidi.sharepoint.com";
  late InAppWebViewController? webViewController;
  double webProgress = 0;
  String? accessToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initialDataValues();

      await _restoreCookies();
      // if (mounted) {
      //   webViewController.loadUrl(
      //     urlRequest: URLRequest(url: WebUri(sharepointUrl)),
      //   );
      // }
    });
    SecureStorageService().getData("SharePointAccessToken").then((value) {
      setState(() {
        AppNotifier.logWithScreen(
            "Dashboard Screen", "DashBoard Token: $value");
        accessToken = value.trim();
      });
    });
  }

  void initialDataValues() {
    final userProvider = context.read<UserInfoProvider>();
    final imageProvider = context.read<UserImageProvider>();
    final managerProvider = context.read<ManagerInfoProvider>();
    final directReportProvider = context.read<DirectReportsProvider>();
    final allUsersProvider = context.read<AllOrganizationUsersProvider>();

    userProvider.fetchUserInfo();
    userProvider.getGroupId(true);
    userProvider.getGroupMembers("4053f91a-d9a0-4a65-8057-1a816e498d0f");
    imageProvider.fetchImage();
    managerProvider.fetchManagerInfo();
    allUsersProvider.getAllUsers();
    if (directReportProvider.directReportList == null) {
      directReportProvider.fetchRedirectReport();
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

    // نخزنهم كـ JSON String
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
    final userInfoProvider = context.watch<UserInfoProvider>();
    final userInfo = userInfoProvider.userInfo;
    final managerOfSalesGroup = userInfoProvider.groupInfo;

    if (userInfo != null && managerOfSalesGroup != null) {
      AppNotifier.logWithScreen("Dashboard Screen",
          "User Info: ${userInfo.id} ${managerOfSalesGroup.groupId}");

      SharedPrefsHelper().saveUserData("UserId", userInfo.id);
      SharedPrefsHelper().saveUserData("managerOfSalesGroup", managerOfSalesGroup.groupId);
    }

    final theme = context.theme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
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
      ),
    );
  }
}
