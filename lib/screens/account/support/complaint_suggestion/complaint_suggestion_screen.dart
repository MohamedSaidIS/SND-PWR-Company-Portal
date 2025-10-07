import 'dart:typed_data';
import 'package:company_portal/models/remote/user_info.dart';
import 'package:company_portal/providers/sp_ensure_user.dart';
import 'package:company_portal/screens/account/support/widget/common_support_appbar.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_notifier.dart';
import 'complaint_suggestion_form_screen.dart';
import 'history_screen.dart';

class ComplaintSuggestionScreen extends StatelessWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;

  const ComplaintSuggestionScreen(
      {required this.userInfo, required this.userImage, super.key});

  // @override
  @override
  Widget build(BuildContext context) {
    final ensureUserProvider = context.watch<SPEnsureUserProvider>();
    final ensureUser = ensureUserProvider.ensureUser;

    final local = context.local;

    if (!ensureUserProvider.loading && ensureUserProvider.error == null) {
      AppNotifier.logWithScreen("ComplaintSuggestion Screen",
          "EnsureUser: ${ensureUser?.id} ${ensureUser?.email}");
    }

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
            HistoryScreen(
              userInfo: userInfo,
              userImage: userImage,
            ),
          ],
        ),
    );
  }
}
