import 'dart:typed_data';
import 'package:company_portal/data/menu_data.dart';
import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class MenuSection extends StatefulWidget {
  final UserInfo? userInfo;
  final VoidCallback onLogout;
  final Uint8List? userImage;

  const MenuSection({super.key,
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

    items = getMenuItems(
        local, theme, widget.userInfo!, widget.userImage!, widget.onLogout);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return MenuWidget(
            item: items[index],
          );
        },
        childCount: items.length,
      ),
    );
  }
}
