import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../utils/app_separators.dart';
import '../../widgets/menu_widget.dart';
import 'complain_suggestion/complain_suggestion_screen.dart';
import 'language/language_screen.dart';
import 'notification/notification_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.themeProvider;
    final theme = context.theme;
    final local = context.local;
    final backIcon = context.backIcon;
    final themeIcon = context.themeIcon;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: theme.appBarTheme.backgroundColor,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              backIcon,
              color: theme.colorScheme.primary,
            ),
          ),
          title: Text(local.settings, style: theme.textTheme.headlineLarge),
          actions: [
            IconButton(
              onPressed: () => themeProvider.toggleTheme(),
              icon: Icon(
                themeIcon,
                color: theme.colorScheme.primary,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
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
                  //textColor: theme.colorScheme.primary,
                  navigatedPage: () => const NotificationScreen(),
                ),
                MenuWidget(
                  title: local.language,
                  icon: LineAwesomeIcons.language_solid,
                  //textColor: theme.colorScheme.primary,
                  navigatedPage: () => const LanguageScreen(),
                ),
                AppSeparators.dividerSeparate(),
                MenuWidget(
                  title: local.complainAndSuggestion,
                  icon: LineAwesomeIcons.hands_helping_solid,
                  //textColor: theme.colorScheme.primary,
                  navigatedPage: () => const ComplainSuggestionScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
