import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../utils/export_import.dart';

class MenuSection extends StatefulWidget {
  final UserInfo? userInfo;
  final VoidCallback onLogout;
  final Uint8List? userImage;

  const MenuSection(
      {super.key,
      required this.userInfo,
      required this.onLogout,
      this.userImage});

  @override
  State<MenuSection> createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection> {
  List<MenuItem> items = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = context.theme;
    final local = context.local;
    AppNotifier.logWithScreen("Menu Screen", "Image: ${widget.userImage}");

    items = [
      MenuItem(
        title: local.userInformation,
        icon: LineAwesomeIcons.user,
        navigatedPage: () => UserInfoDetailsScreen(
          userInfo: widget.userInfo!,
        ),
        textColor: theme.colorScheme.primary,
      ),
      MenuItem(
        title: local.directReport,
        icon: LineAwesomeIcons.book_solid,
        navigatedPage: () => const DirectReportsScreen(),
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
        navigatedPage: () => SupportScreen(
            userInfo: widget.userInfo, userImage: widget.userImage),
        addSeparator: true,
      ),
      MenuItem(
        title: local.logout,
        icon: LineAwesomeIcons.sign_out_alt_solid,
        endIcon: false,
        textColor: theme.colorScheme.secondaryContainer,
        logout: widget.onLogout,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return MenuWidget(
          item: item,
        );
      },
    );
  }
}
