import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../common/custom_app_bar.dart';
import '../../utils/app_separators.dart';
import '../account/profile/widgets/menu_widget.dart';
import 'complaint_suggestion/complaint_suggestion_screen.dart';
import 'language/language_screen.dart';
import 'notification/notification_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String userName;
  const SettingsScreen({ required this.userName, super.key});

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
        backgroundColor: theme.colorScheme.background,
        appBar: CustomAppBar(
          title: local.settings,
          backBtn: true,
          themeBtn: true,
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
                  title: local.complaintAndSuggestion,
                  icon: LineAwesomeIcons.hands_helping_solid,
                  //textColor: theme.colorScheme.primary,
                  navigatedPage: () => ComplaintSuggestionScreen(userName: widget.userName,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
