import 'dart:typed_data';
import 'package:company_portal/providers/direct_reports_provider.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/custom_app_bar.dart';
import '../../../data/support_data.dart';
import '../../../models/remote/user_info.dart';
import '../../../providers/sp_ensure_user.dart';
import 'complaint_suggestion/screens/complaint_suggestion_screen.dart';
import 'dynamics_support_case/screens/dynamics_support_case_screen.dart';
import 'ecommerce_support_case/screens/ecommerce_support_case_screen.dart';
import 'user_new_requests/screens/user_new_request_screen.dart';

class SupportScreen extends StatefulWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;

  const SupportScreen(
      {required this.userInfo, required this.userImage, super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SPEnsureUserProvider>();

      if(widget.userInfo != null){
        provider.fetchITSiteEnsureUser("${widget.userInfo!.mail}", context);
        provider.fetchDynamicsSiteEnsureUser("${widget.userInfo!.mail}");
        provider.fetchAlsanidiSiteEnsureUser("${widget.userInfo!.mail}");
      }
    });
  }

  void navigatedScreen(BuildContext context, String screenName) {
    Widget navigatedScreenWidget = ComplaintSuggestionScreen(userInfo: widget.userInfo, userImage: widget.userImage);
    switch (screenName) {
      case "Issue and Request \nTracking":
        navigatedScreenWidget = ComplaintSuggestionScreen(userInfo: widget.userInfo, userImage: widget.userImage);
        break;

      case "Users New \nRequests":
        navigatedScreenWidget = UserNewRequestScreen(userInfo: widget.userInfo, userImage: widget.userImage);
        break;

      case "Dynamic365 \nSupport Cases":
        navigatedScreenWidget =  DynamicsSupportCaseScreen(userInfo: widget.userInfo, userImage: widget.userImage);
        break;

      case "ECommerce \nSupport Cases":
        navigatedScreenWidget =  EcommerceSupportCaseScreen(userInfo: widget.userInfo, userImage: widget.userImage);
        break;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return navigatedScreenWidget;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final directReportList = context.watch<DirectReportsProvider>().directReportList;
    final theme = context.theme;
    final local = context.local;
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: CustomAppBar(
          title: local.support,
          backBtn: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: getSupportItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final item = getSupportItems[index];
              return (item.name == "Users New \nRequests" &&  directReportList != null && directReportList.isEmpty)
                  ? const SizedBox.shrink()
                  : _SupportCard(
                title: item.name,
                image: item.image,
                onTap: () => navigatedScreen(context, item.name),
                colorScheme: colorScheme,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SupportCard extends StatefulWidget {
  final String title;
  final String image;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _SupportCard({
    required this.title,
    required this.image,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  State<_SupportCard> createState() => _SupportCardState();
}

class _SupportCardState extends State<_SupportCard> {

  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 150),
      scale: _isPressed ? 0.95 : 1.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 3,
          shadowColor: Colors.black12,
          color: widget.colorScheme.primary.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.colorScheme.surface.withValues(alpha: 0.5),
                  ),
                  child: Center(
                    child: Image.asset(
                      widget.image,
                      width: 55,
                      height: 55,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
