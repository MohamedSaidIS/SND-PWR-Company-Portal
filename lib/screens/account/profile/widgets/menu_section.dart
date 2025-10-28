import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../utils/export_import.dart';

class MenuSection extends StatelessWidget {
  final UserInfo? userInfo;
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
    AppNotifier.logWithScreen("Menu Screen","Image: $userImage");

    return Column(
      children: [
        MenuWidget(
          title: local.userInformation,
          icon: LineAwesomeIcons.user,
          navigatedPage: () => UserInfoDetailsScreen(
              userName: "${userInfo?.givenName} ${userInfo?.surname}",
              userPhone: userInfo?.mobilePhone ?? "",
              userOfficeLocation: userInfo?.officeLocation ?? ""),
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
          title: local.support,
          icon: LineAwesomeIcons.hands_helping_solid,
          //textColor: theme.colorScheme.primary,
          navigatedPage: () => SupportScreen(
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
