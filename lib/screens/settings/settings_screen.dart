
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../utils/export_import.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.settings,
          backBtn: true,
          themeBtn: true,
        ),
        body: UpFadeSlideAnimation(
          delay: 0,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  MenuWidget(
                    title: local.notifications,
                    icon: LineAwesomeIcons.bell,
                    navigatedPage: () => const NotificationScreen(),
                  ),
                  MenuWidget(
                    title: local.language,
                    icon: LineAwesomeIcons.language_solid,
                    navigatedPage: () => const LanguageScreen(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
