import 'dart:typed_data';
import 'package:company_portal/screens/support/features/user_new_requests/bloc/new_user_bloc/new_user_bloc.dart';
import 'package:company_portal/screens/support/features/user_new_requests/bloc/new_user_form_bloc/new_user_form_bloc.dart';
import 'package:company_portal/screens/support/features/user_new_requests/repo/new_user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:company_portal/utils/export_import.dart';


class UserNewRequestScreen extends StatelessWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;

  const UserNewRequestScreen(
      {required this.userInfo, required this.userImage, super.key});

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final ensureUser = context.select((SupportBloc bloc) => bloc.state.itUser);

    final repo = NewUserRepo(SharePointDioClient());

    return PopScope(
      canPop: false,
      child: BlocProvider(
        create: (context) => NewUserFormBloc(repo),
        child: CommonSupportAppbar(
          title: local.userNewRequest,
          tabTitle: local.userNewRequest,
          tabBarChildren: [
            UserNewRequestFormScreen(
              userName: "${userInfo?.givenName} ${userInfo?.surname}",
              ensureUserId: ensureUser?.id ?? -1,
              newUserItem: null,
            ),
            BlocProvider(
              create: (context) => NewUserBloc(repo),
              child: NewUserRequestHistory(ensureUserId: ensureUser?.id ?? -1,),
            ),
          ],
        ),
      ),
    );
  }
}
