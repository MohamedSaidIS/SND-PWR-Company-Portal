import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/export_import.dart';

class SharePointLauncherScreen extends StatefulWidget {
  const SharePointLauncherScreen({super.key});

  @override
  State<SharePointLauncherScreen> createState() =>
      _SharePointLauncherScreenState();
}

class _SharePointLauncherScreenState
    extends State<SharePointLauncherScreen> {
  static const _sharePointUrl = 'https://alsanidi.sharepoint.com';
  // alsanidi.sharepoint.com
  late final WebViewController _controller;
  double _progress = 0;
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _initWebView();
    _loadToken();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (!mounted) return;
            setState(() => _progress = p / 100);
          },
          onWebResourceError: (error) {
            AppLogger.error("WebView", error.description);
          },
        ),
      )
    // ..setNavigationDelegate(
    //   NavigationDelegate(
    //     onNavigationRequest: (NavigationRequest request) {
    //       final uri = Uri.parse(request.url);
    //
    //       // لو الدومين مش sharepoint → افتحيه برّه
    //       if (uri.host == 'alsanidi.sharepoint.com') {
    //         AppLogger.info("Host Url", uri.host);
    //         _launchUrl(request.url);
    //         return NavigationDecision.prevent;
    //       }
    //       AppLogger.info("Host Url After", uri.host);
    //       // أي حاجة من SharePoint (حتى login / auth)
    //        return NavigationDecision.navigate;
    //
    //     },
    //   ),
    // )
      ..loadRequest(Uri.parse(_sharePointUrl));
  }

  Future<void> _loadToken() async {
    final token = await SecureStorageService().getData("SPAccessToken");
    if (!mounted) return;
    setState(() => _accessToken = token.trim());
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
      webViewConfiguration: const WebViewConfiguration(
        enableDomStorage: true,
        enableJavaScript: true
      )
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body:  SafeArea(
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
                  : WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }}

