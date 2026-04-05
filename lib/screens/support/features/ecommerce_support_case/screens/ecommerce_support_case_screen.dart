import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:company_portal/utils/export_import.dart';


class EcommerceSupportCaseScreen extends StatelessWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;
  const EcommerceSupportCaseScreen({required this.userInfo, required this.userImage,super.key});

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final repo = EcommerceRepo(SharePointDioClient());
    final ensureUser = context.select((SupportBloc bloc) => bloc.state.alsanidiUser);

    return PopScope(
      canPop: false,
      child: CommonSupportAppbar(
      title: local.ecommerceSupportCase,
      tabTitle: local.ecommerceSupportCase,
      tabBarChildren: [
        BlocProvider(
          create: (context) => ECommerceFormBloc(repo),
        child: EcommerceScFormScreen(
          userName: "${userInfo?.givenName} ${userInfo?.surname}",
          ensureUserId: ensureUser?.id ?? -1,
        ),
      ),
        BlocProvider(
          create: (context) => ECommerceBloc(repo),
        child: EcommerceHistoryScreen(ensureUserId: ensureUser?.id ?? -1, userInfo: userInfo, userImage: userImage,),),
      ],
      ),
    );
  }
}
