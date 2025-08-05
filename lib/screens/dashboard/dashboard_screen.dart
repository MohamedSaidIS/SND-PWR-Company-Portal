import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late InAppWebViewController webViewController;
  double webProgress = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: theme.colorScheme.background,
          body: Column(
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
                        URLRequest(url: WebUri("https://alsanidi.sharepoint.com/")),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      cacheEnabled: true,
                      clearCache: false,
                      // do NOT clear cache
                      domStorageEnabled: true,
                      sharedCookiesEnabled: true,
                      thirdPartyCookiesEnabled: true,
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
          )
      ),
    );
  }
}
