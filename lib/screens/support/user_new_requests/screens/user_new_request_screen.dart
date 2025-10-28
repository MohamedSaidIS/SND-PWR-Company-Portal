import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';


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
