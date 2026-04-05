import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:company_portal/utils/export_import.dart';

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
    final repo = DynamicsRepo(MySharePointDioClient());
    final ensureUser = context.select((SupportBloc bloc) => bloc.state.dynamicsUser);

    return PopScope(
      canPop: false,
      child: CommonSupportAppbar(
        title: local.dynamicsSupportCase,
        tabTitle: local.dynamicsSupportCase,
        tabBarChildren: [
          BlocProvider(
            create: (context) =>
                DynamicsFormBloc(repo),
            child: DynamicsScFormScreen(
              userName: "${userInfo?.givenName} ${userInfo?.surname}",
              ensureUserId: ensureUser?.id ?? -1,
            ),
          ),
          BlocProvider(
            create: (context) => DynamicsBloc(repo),
            child: DynamicsHistoryScreen(
              userInfo: userInfo,
              userImage: userImage,
              ensureUserId: ensureUser?.id ?? -1,
            ),
          ),
        ],
      ),
    );
  }
}
