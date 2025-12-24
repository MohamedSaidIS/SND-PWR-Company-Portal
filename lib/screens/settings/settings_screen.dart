import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../utils/export_import.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<MenuItem> items = [];
  late AppLocalizations local;
  late ThemeData theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    local = context.local;
    theme = context.theme;
    items = [
      MenuItem(
        title: local.notifications,
        isNotification: true,
        icon: LineAwesomeIcons.bell,
        navigatedPage: () => const NotificationScreen(),
      ),
      MenuItem(
        title: local.language,
        icon: LineAwesomeIcons.language_solid,
        navigatedPage: () => const LanguageScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.settings,
          backBtn: true,
          themeBtn: true,
        ),
        body: SideFadeSlideAnimation(
          delay: 0,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return MenuWidget(
                    item: item,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
