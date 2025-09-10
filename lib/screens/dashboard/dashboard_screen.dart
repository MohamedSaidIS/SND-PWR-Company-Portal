import 'package:company_portal/service/sharedpref_service.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../../providers/user_info_provider.dart';
import '../../utils/secure_storage_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late InAppWebViewController webViewController;
  double webProgress = 0;
  String? accessToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final userProvider = context.read<UserInfoProvider>();
      userProvider.fetchUserInfo();
    });
    SecureStorageService().getData("AccessToken").then((value) {
      print("Token: $value");
      accessToken = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = context.watch<UserInfoProvider>();
    final userInfo = userInfoProvider.userInfo;

    if(userInfo != null){
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
                    backgroundColor: theme.colorScheme.primary,
                    minHeight: 4,
                  ),
                Expanded(
                  child: InAppWebView(
                      initialUrlRequest:
                          URLRequest(
                              url: WebUri("https://alsanidi.sharepoint.com/"),
                          // headers: {
                          //       "Authorization": "Bearer $accessToken",
                          // }
                          ),
                      initialSettings: InAppWebViewSettings(
                        javaScriptEnabled: true,
                        cacheEnabled: true,
                        clearCache: false,
                        // do NOT clear cache
                        domStorageEnabled: true,
                        sharedCookiesEnabled: true,
                        thirdPartyCookiesEnabled: true,
                        useHybridComposition: true
                      ),
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStop: (controller, url) {
                        print("Finished loading: $url");
                      },
                      onProgressChanged: (controller, progress) {
                        setState(() {
                          webProgress = progress / 100;
                          print("Progress $progress%");
                        });
                      }
                      ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
