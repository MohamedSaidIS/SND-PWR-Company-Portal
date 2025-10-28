import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';



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
