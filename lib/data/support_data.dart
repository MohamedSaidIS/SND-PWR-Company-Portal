import 'package:company_portal/l10n/app_localizations.dart';

class SupportItem {
  final String name;
  final String translatedName;
  final String image;

  const SupportItem({
    required this.name,
    required this.translatedName,
    required this.image,
  });
}

List<SupportItem> getSupportItems(AppLocalizations local ){
  return [
    SupportItem(
      name: "Issue and Request \nTracking",
      translatedName: local.issueRequestTracking,
      image: 'assets/images/issue_tracker.png',
    ),
    SupportItem(
      name: "Dynamic365 \nSupport Cases",
      translatedName: local.dynamic365SupportCases,
      image: 'assets/images/dynamics_support.png',
    ),
    SupportItem(
      name: "ECommerce \nSupport Cases",
      translatedName: local.eCommerceSupportCases,
      image: 'assets/images/ecommerce.png',
    ),
    SupportItem(
      name: "Users New \nRequests",
      translatedName: local.usersNewRequests,
      image: 'assets/images/user_new_request.png',
    ),
  ];
}
