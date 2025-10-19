import 'dart:typed_data';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/remote/user_info.dart';
import '../../../../providers/sp_ensure_user.dart';
import '../common_widgets/common_support_appbar.dart';
import 'ecommerce_history_screen.dart';
import 'ecommerce_sc_form_screen.dart';


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
        title: local.userNewRequest,
        tabTitle: local.userNewRequest,
        tabBarChildren: [
          EcommerceScFormScreen(
            userName: "${userInfo?.givenName} ${userInfo?.surname}",
            ensureUserId: ensureUser?.id ?? -1,
          ),
          EcommerceHistoryScreen(ensureUserId: ensureUser?.id ?? -1, userInfo: null, userImage: null,),
        ],
      ),
    );
  }
}
