import 'dart:typed_data';

import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../utils/app_separators.dart';
import '../../complaint_suggestion/complaint_suggestion_screen.dart';
import 'menu_widget.dart';
import '../../../settings/settings_screen.dart';
import '../../redirect_reports/redirect_reports_screen.dart';
import '../../user_info/user_info_details_screen.dart';

class MenuSection extends StatelessWidget {
  final dynamic userInfo;
  final VoidCallback onLogout;
  final Uint8List? userImage;

  const MenuSection({
    super.key,
    required this.userInfo,
    required this.onLogout,
    this.userImage
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    print("Image: ${userImage}");

    return Column(
      children: [
        MenuWidget(
          title: local.userInformation,
          icon: LineAwesomeIcons.user,
          navigatedPage: () => UserInfoDetailsScreen(
              userName: "${userInfo.givenName} ${userInfo.surname}",
              userPhone: userInfo.mobilePhone,
              userOfficeLocation: userInfo.officeLocation),
          textColor: theme.colorScheme.primary,
        ),
        MenuWidget(
          title: local.directReport,
          icon: LineAwesomeIcons.book_solid,
          navigatedPage: () => const DirectReportsScreen(),
          textColor: theme.colorScheme.primary,
        ),
        AppSeparators.dividerSeparate(),
        MenuWidget(
          title: local.settings,
          icon: LineAwesomeIcons.cog_solid,
          navigatedPage: () => const SettingsScreen(),
          textColor: theme.colorScheme.primary,
        ),
        MenuWidget(
          title: local.complaintAndSuggestion,
          icon: LineAwesomeIcons.hands_helping_solid,
          //textColor: theme.colorScheme.primary,
          navigatedPage: () => ComplaintSuggestionScreen(
            userInfo: userInfo,
            userImage: userImage),
        ),
        AppSeparators.dividerSeparate(),
        MenuWidget(
          title: local.logout,
          icon: LineAwesomeIcons.sign_out_alt_solid,
          endIcon: false,
          textColor: theme.colorScheme.secondaryContainer,
          logout: onLogout,
        ),
      ],
    );
  }
}
