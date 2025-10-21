import 'dart:typed_data';

import 'package:company_portal/screens/support/dynamics_support_case/screens/dynamics_history_screen.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../models/remote/user_info.dart';
import '../../../../../providers/sp_ensure_user.dart';
import '../../common_widgets/common_support_appbar.dart';
import '../../complaint_suggestion/screens/complaint_suggestion_history_screen.dart';
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
    final ensureUser = context.watch<SPEnsureUserProvider>().dynamicsEnsureUser;

    return PopScope(
      canPop: false,
      child: CommonSupportAppbar(
        title: local.dynamicsSupportCase,
        tabTitle: local.dynamicsSupportCase,
        tabBarChildren: [
          DynamicsScFormScreen(
            userName: "${userInfo?.givenName} ${userInfo?.surname}",
            ensureUserId: ensureUser?.id ?? -1,
          ),
          DynamicsHistoryScreen(
            userInfo: userInfo,
            userImage: userImage,
            ensureUserId: ensureUser?.id ?? -1,
          ),
        ],
      ),
    );
  }
}
