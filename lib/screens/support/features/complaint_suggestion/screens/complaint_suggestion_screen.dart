import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:company_portal/utils/export_import.dart';
class ComplaintSuggestionScreen extends StatelessWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;


  const ComplaintSuggestionScreen(
      {required this.userInfo, required this.userImage, super.key});

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final repo = ComplaintRepo(SharePointDioClient());
    final ensureUser = context.select((SupportBloc bloc) => bloc.state.itUser);

    return PopScope(
      canPop: false,
      child: CommonSupportAppbar(
        title: local.complaintAndSuggestion,
        tabTitle: local.complaintSuggestionHeader,
        tabBarChildren: [
          BlocProvider(
            create: (context) => ComplaintFormBloc(repo),
            child: ComplaintSuggestionFormScreen(
              userName: "${userInfo?.givenName} ${userInfo?.surname}",
              ensureUserId: ensureUser?.id ?? -1,
            ),
          ),
          BlocProvider(
            create: (context) => ComplaintBloc(repo),
            child: ComplaintSuggestionHistoryScreen(
              userInfo: userInfo!,
              userImage: userImage,
              ensureUserId: ensureUser?.id ?? -1,
            ),
          ),
        ],
      ),
    );
  }
}
