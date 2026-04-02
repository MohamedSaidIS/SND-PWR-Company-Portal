import 'dart:typed_data';
import 'package:company_portal/screens/support/complaint_suggestion/bloc/complaint_bloc/complaint_bloc.dart';
import 'package:company_portal/screens/support/complaint_suggestion/repo/complaint_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class ComplaintSuggestionScreen extends StatelessWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;


  const ComplaintSuggestionScreen(
      {required this.userInfo, required this.userImage, super.key});

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final ensureUser = context
        .watch<SPEnsureUserProvider>()
        .itEnsureUser;
    final repo = ComplaintRepo(SharePointDioClient());

    AppNotifier.logWithScreen(
        "ComplaintSuggestion Screen", "Image: ${userImage != null}");

    return PopScope(
      canPop: false,
      child: CommonSupportAppbar(
        title: local.complaintAndSuggestion,
        tabTitle: local.complaintSuggestionHeader,
        tabBarChildren: [
          ComplaintSuggestionFormScreen(
            userName: "${userInfo?.givenName} ${userInfo?.surname}",
            ensureUserId: ensureUser?.id ?? -1,
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
