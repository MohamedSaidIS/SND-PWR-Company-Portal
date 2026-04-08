import 'dart:typed_data';

import 'package:company_portal/screens/account/profile/profile_bloc/profile_bloc.dart';
import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

List<MenuItem> getMenuItems(AppLocalizations local, ThemeData theme,
    UserInfo userInfo, Uint8List userImage, VoidCallback onLogout,
    BuildContext context) {
  return [
    MenuItem(
      title: local.userInformation,
      icon: LineAwesomeIcons.user,
      navigatedPage: () =>
          BlocProvider.value(
            value: context.read<ProfileBloc>(),
            child: UserInfoDetailsScreen(
              userInfo: userInfo,
            ),
          ),
      textColor: theme.colorScheme.primary,
    ),
    MenuItem(
      title: local.directReport,
      icon: LineAwesomeIcons.book_solid,
      navigatedPage: () =>
          BlocProvider.value(
              value: context.read<ProfileBloc>(),
              child: const DirectReportsScreen()
          ),
      textColor: theme.colorScheme.primary,
      addSeparator: true,
    ),
    MenuItem(
      title: local.settings,
      icon: LineAwesomeIcons.cog_solid,
      navigatedPage: () => const SettingsScreen(),
      textColor: theme.colorScheme.primary,
    ),
    MenuItem(
      title: local.support,
      icon: LineAwesomeIcons.hands_helping_solid,
      textColor: theme.colorScheme.primary,
      navigatedPage: () =>
          BlocProvider.value(
            value: context.read<ProfileBloc>(),
            child: SupportScreen(
                userInfo: userInfo, userImage: userImage),
          ),
      addSeparator: true,
    ),
    MenuItem(
      title: local.logout,
      icon: LineAwesomeIcons.sign_out_alt_solid,
      endIcon: false,
      textColor: theme.colorScheme.secondaryContainer,
      logout: onLogout,
    )
  ];
}