import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';


class EcommerceSupportCaseScreen extends StatelessWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;
  const EcommerceSupportCaseScreen({required this.userInfo, required this.userImage,super.key});

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final ensureUser = context.watch<SPEnsureUserProvider>().alsanidiSiteEnsureUser;

    return PopScope(
      canPop: false,
      child: CommonSupportAppbar(
        title: local.ecommerceSupportCase,
        tabTitle: local.ecommerceSupportCase,
        tabBarChildren: [
          EcommerceScFormScreen(
            userName: "${userInfo?.givenName} ${userInfo?.surname}",
            ensureUserId: ensureUser?.id ?? -1,
          ),
          EcommerceHistoryScreen(ensureUserId: ensureUser?.id ?? -1, userInfo: userInfo, userImage: userImage,),
        ],
      ),
    );
  }
}
