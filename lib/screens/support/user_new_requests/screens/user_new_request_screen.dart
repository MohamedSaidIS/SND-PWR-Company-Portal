import 'dart:typed_data';

import 'package:company_portal/screens/support/user_new_requests/screens/user_new_request_form_screen.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../models/remote/user_info.dart';
import '../../../../../providers/sp_ensure_user.dart';
import '../../common_widgets/common_support_appbar.dart';
import 'new_user_request_history.dart';


class UserNewRequestScreen extends StatelessWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;

  const UserNewRequestScreen({required this.userInfo, required this.userImage, super.key});

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final ensureUser = context.watch<SPEnsureUserProvider>().itEnsureUser;

    return PopScope(
      canPop: false,
      child: CommonSupportAppbar(
        title: local.userNewRequest,
        tabTitle: local.userNewRequest,
        tabBarChildren: [
          UserNewRequestFormScreen(
            userName: "${userInfo?.givenName} ${userInfo?.surname}",
            ensureUserId: ensureUser?.id ?? -1,
            newUserRequest: null,
          ),
          NewUserRequestHistory(ensureUserId: ensureUser?.id ?? -1,),
        ],
      ),
    );
  }
}
