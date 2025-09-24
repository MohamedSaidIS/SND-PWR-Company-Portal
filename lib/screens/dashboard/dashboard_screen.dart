import 'dart:convert';

import 'package:company_portal/service/sharedpref_service.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../../providers/user_info_provider.dart';
import '../../service/secure_storage_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final CookieManager cookieManager = CookieManager.instance();
  final String sharepointUrl = "https://alsanidi.sharepoint.com";
  late InAppWebViewController webViewController;
  double webProgress = 0;
  String? accessToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = context.read<UserInfoProvider>();
      userProvider.fetchUserInfo();

      await _restoreCookies();
      // if (mounted) {
      //   webViewController.loadUrl(
      //     urlRequest: URLRequest(url: WebUri(sharepointUrl)),
      //   );
      // }
    });
    SecureStorageService().getData("SharePointAccessToken").then((value) {
      setState(() {
        print("DashBoard Token: $value");
        accessToken = value.trim();
      });
    });
  }

  Future<void> _restoreCookies() async {
    final cookiesJson = await SecureStorageService().getData("savedCookies");
    if (cookiesJson == null) return;

    final cookiesList = jsonDecode(cookiesJson) as List;

    for (var c in cookiesList) {
      final value = c["value"];
      if (value != null && value.toString().isNotEmpty) {
        String domain = c["domain"];

        print("✅ Restored Cookie: ${c["name"]} =========== $value");

        if (c["name"] == "FedAuth" || c["name"] == "rtFa") {
          domain = ".sharepoint.com";
          print("✅ Restored Cookie Domain: $domain");
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
        print("Restored Cookie: ${c["name"]}=$value; domain=$domain");
      }
    }

    if (mounted) {
      await webViewController.loadUrl(
        urlRequest: URLRequest(url: WebUri(sharepointUrl)),
      );
    }

    print("✅ Cookies restored and WebView reloaded");
  }

  Future<void> _saveCookies() async {
    final cookies = await cookieManager.getCookies(url: WebUri(sharepointUrl));
    for (var c in cookies) {
      print("Restored Cookie: ${c.name}=${c.value}; domain=${c.domain}");
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

    print("Cookies saved to storage: $cookiesJson");
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = context.watch<UserInfoProvider>();
    final userInfo = userInfoProvider.userInfo;

    if (userInfo != null) {
      print("User Info: ${userInfo.id}");
      SharedPrefsHelper().saveUserData("UserId", userInfo.id);
    }

    final theme = context.theme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
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
                  initialUrlRequest: URLRequest(url: WebUri(sharepointUrl),
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
                    print("Finished loading: $url");
                    await _saveCookies();
                  },
                  onProgressChanged: (controller, progress) {
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
