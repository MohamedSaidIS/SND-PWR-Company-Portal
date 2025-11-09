import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../utils/export_import.dart';

void navigatedScreen(BuildContext context, String screenName, UserInfo? userInfo, Uint8List? userImage, ) {
  Widget navigatedScreenWidget = ComplaintSuggestionScreen(
      userInfo: userInfo, userImage: userImage);
  switch (screenName) {
    case "Issue and Request \nTracking":
      navigatedScreenWidget = ComplaintSuggestionScreen(
          userInfo: userInfo, userImage: userImage);
      break;

    case "Users New \nRequests":
      navigatedScreenWidget = UserNewRequestScreen(
          userInfo: userInfo, userImage: userImage);
      break;

    case "Dynamic365 \nSupport Cases":
      navigatedScreenWidget = DynamicsSupportCaseScreen(
          userInfo: userInfo, userImage: userImage);
      break;

    case "ECommerce \nSupport Cases":
      navigatedScreenWidget = EcommerceSupportCaseScreen(
          userInfo: userInfo, userImage: userImage);
      break;
  }
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return navigatedScreenWidget;
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

Widget supportCard(
    String title, String image, ColorScheme colorScheme, bool isAnimated) {
  return ScaleAnimation(
    isAnimated: isAnimated,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.primary.withValues(alpha: 0.15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 85,
              width: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface.withValues(alpha: 0.5),
              ),
              child: Center(
                child: Image.asset(
                  image,
                  width: 55,
                  height: 55,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}