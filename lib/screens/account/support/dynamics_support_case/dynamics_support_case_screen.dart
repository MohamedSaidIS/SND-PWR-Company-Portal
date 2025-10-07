import 'dart:typed_data';

import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/remote/user_info.dart';
import '../../../../providers/sp_ensure_user.dart';
import '../complaint_suggestion/history_screen.dart';
import '../widget/common_support_appbar.dart';
import 'dynamics_sc_form_screen.dart';


class DynamicsSupportCaseScreen extends StatelessWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;

  const DynamicsSupportCaseScreen({
    required this.userInfo,
    required this.userImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final ensureUserProvider = context.watch<SPEnsureUserProvider>();
    final ensureUser = ensureUserProvider.ensureUser;

    return PopScope(
      canPop: false,
      child: CommonSupportAppbar(
        title: local.userNewRequest,
        tabTitle: local.userNewRequest,
        tabBarChildren: [
          DynamicsScFormScreen(
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
