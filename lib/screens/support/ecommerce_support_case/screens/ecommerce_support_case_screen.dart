import 'dart:typed_data';
import 'package:company_portal/screens/support/ecommerce_support_case/bloc/e_commerce_form_bloc/e_commerce_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';
import '../bloc/e_commerce_bloc/e_commerce_bloc.dart';
import '../repo/ecommerce_repo.dart';


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
        BlocProvider(
          create: (context) => ECommerceFormBloc(EcommerceRepo(SharePointDioClient())),
        child: EcommerceScFormScreen(
          userName: "${userInfo?.givenName} ${userInfo?.surname}",
          ensureUserId: ensureUser?.id ?? -1,
        ),
      ),
        BlocProvider(
          create: (context) => ECommerceBloc(EcommerceRepo(SharePointDioClient())),
        child: EcommerceHistoryScreen(ensureUserId: ensureUser?.id ?? -1, userInfo: userInfo, userImage: userImage,),),
      ],
      ),
    );
  }
}
