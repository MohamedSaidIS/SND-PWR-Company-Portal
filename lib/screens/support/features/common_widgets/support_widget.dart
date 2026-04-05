import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:company_portal/utils/export_import.dart';
void navigatedScreen(BuildContext context, String screenName, UserInfo? userInfo, Uint8List? userImage, ) {
  Widget screen = ComplaintSuggestionScreen(userInfo: userInfo, userImage: userImage);

  switch (screenName) {
    case "Issue and Request \nTracking":
      screen = ComplaintSuggestionScreen(
          userInfo: userInfo, userImage: userImage);
      break;

    case "Users New \nRequests":
      screen = UserNewRequestScreen(
          userInfo: userInfo, userImage: userImage);
      break;

    case "Dynamic365 \nSupport Cases":
      screen = DynamicsSupportCaseScreen(
          userInfo: userInfo, userImage: userImage);
      break;

    case "ECommerce \nSupport Cases":
      screen = EcommerceSupportCaseScreen(
          userInfo: userInfo, userImage: userImage);
      break;
  }
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) {
        return BlocProvider.value(
            value: context.read<SupportBloc>(),
            child: screen
        );
      },
    ),
  );
}

String supportTitle(String title, AppLocalizations local) {
  var translatedTitle = '';
  switch (title) {
    case "Issue and Request \nTracking":
      translatedTitle = local.issueRequestTracking;
      break;
    case "Users New \nRequests":
      translatedTitle = local.usersNewRequests;
      break;
    case "Dynamic365 \nSupport Cases":
      translatedTitle = local.dynamic365SupportCases;
      break;
    case "ECommerce \nSupport Cases":
      translatedTitle = local.eCommerceSupportCases;
      break;
  }
  return translatedTitle;
}