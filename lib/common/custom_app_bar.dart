import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  final String title;
  final void Function()? onBack;
  final bool backBtn;
  final bool themeBtn;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.backBtn = false,
    this.themeBtn = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final backIcon = context.backIcon;
    final themeProvider = context.themeProvider;
    final themeIcon = context.themeIcon;

    return AppBar(
      centerTitle: true,
      backgroundColor: theme.colorScheme.surface,
      automaticallyImplyLeading: false,
      leading: backBtn
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                backIcon,
                color: theme.colorScheme.primary,
              ))
          : null,
      actions: themeBtn
          ? [
              IconButton(
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                icon: Icon(
                  themeIcon,
                  color: theme.colorScheme.primary,
                ),
              )
            ]
          : null,
      title: Text(title, style: theme.textTheme.headlineLarge),
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
