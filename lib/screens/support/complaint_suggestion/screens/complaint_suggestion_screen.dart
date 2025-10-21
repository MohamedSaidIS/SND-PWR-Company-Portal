import 'dart:typed_data';
import 'package:company_portal/models/remote/user_info.dart';
import 'package:company_portal/providers/sp_ensure_user.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/app_notifier.dart';
import '../../common_widgets/common_support_appbar.dart';
import 'complaint_suggestion_form_screen.dart';
import 'complaint_suggestion_history_screen.dart';

class ComplaintSuggestionScreen extends StatelessWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;

  const ComplaintSuggestionScreen(
      {required this.userInfo, required this.userImage, super.key});

  // @override
  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final ensureUser = context.watch<SPEnsureUserProvider>().itEnsureUser;

    AppNotifier.logWithScreen(
        "ComplaintSuggestion Screen", "Image: ${userImage != null}");

    return PopScope(
        canPop: false,
        child: CommonSupportAppbar(
          title: local.complaintAndSuggestion,
          tabTitle: local.complaintSuggestionHeader,
          tabBarChildren: [
            ComplaintSuggestionFormScreen(
              userName: "${userInfo?.givenName} ${userInfo?.surname}",
              ensureUserId: ensureUser?.id ?? -1,
            ),
            ComplaintSuggestionHistoryScreen(
              userInfo: userInfo,
              userImage: userImage,
            ),
          ],
        ),
    );
  }
}
