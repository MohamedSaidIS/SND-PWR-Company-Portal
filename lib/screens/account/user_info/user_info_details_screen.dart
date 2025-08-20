import 'package:company_portal/providers/manager_info_provider.dart';
import 'package:company_portal/utils/app_separators.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../common/custom_app_bar.dart';

class UserInfoDetailsScreen extends StatefulWidget {
  const UserInfoDetailsScreen(
      {super.key,
        required this.userName,
      required this.userPhone,
      required this.userOfficeLocation});

  final String  userName, userPhone, userOfficeLocation;

  @override
  State<UserInfoDetailsScreen> createState() => _UserInfoDetailsScreenState();
}

class _UserInfoDetailsScreenState extends State<UserInfoDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final managerProvider = Provider.of<ManagerInfoProvider>(context, listen: false);

      if (managerProvider.managerInfo == null) {
        managerProvider.fetchManagerInfo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final managerInfoProvider = Provider.of<ManagerInfoProvider>(context);
    final managerInfo = managerInfoProvider.managerInfo;
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
          appBar: CustomAppBar(
        title: local.userInfo,
        backBtn: true,
      ),
        body:
            managerInfoProvider.loading || managerInfoProvider.managerInfo == null
                ? const Center(child: CircularProgressIndicator())
                : managerInfoProvider.error != null
                    ? Center(child: Text("Error: ${managerInfoProvider.error}"))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              _buildInfoCard([
                                _buildSectionTitle(
                                    local.personalDetails, context, theme),
                                _buildInfoRow(local.name, widget.userName,
                                    LineAwesomeIcons.user, theme),
                                AppSeparators.infoDivider(),
                                _buildInfoRow(local.phone, widget.userPhone,
                                    LineAwesomeIcons.phone_solid, theme),
                                AppSeparators.infoDivider(),
                                _buildInfoRow(
                                    local.location,
                                    widget.userOfficeLocation,
                                    LineAwesomeIcons.map_pin_solid,
                                    theme),
                              ], theme),
                              const SizedBox(height: 20),
                              _buildInfoCard([
                                _buildSectionTitle(
                                    local.managerDetails, context, theme),
                                _buildInfoRow(
                                    local.name,
                                    "${managerInfo!.givenName} ${managerInfo.surname}",
                                    LineAwesomeIcons.user,
                                    theme),
                                AppSeparators.infoDivider(),
                                _buildInfoRow(
                                    local.jobTitle,
                                    managerInfo.jobTitle,
                                    Icons.work_outline,
                                    theme),
                                AppSeparators.infoDivider(),
                                _buildInfoRow(local.email, managerInfo.mail,
                                    LineAwesomeIcons.mail_bulk_solid, theme),
                                AppSeparators.infoDivider(),
                                _buildInfoRow(
                                    local.phone,
                                    managerInfo.mobilePhone,
                                    LineAwesomeIcons.phone_solid,
                                    theme),
                                AppSeparators.infoDivider(),
                                _buildInfoRow(
                                    local.location,
                                    managerInfo.officeLocation,
                                    LineAwesomeIcons.map_pin_solid,
                                    theme),
                              ], theme),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}

Widget _buildSectionTitle(String title, BuildContext context, ThemeData theme) {
  return Align(
    alignment: Alignment.center,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.labelLarge,
      ),
    ),
  );
}

Widget _buildInfoCard(List<Widget> children, ThemeData theme) {
  return Card(
    color: theme.bottomSheetTheme.backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22),
      child: Column(children: children),
    ),
  );
}

Widget _buildInfoRow(
    String label, String value, IconData icon, ThemeData theme) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
            flex: 2,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                Text(label, style: theme.textTheme.labelMedium),
              ],
            )),
        Expanded(flex: 3, child: Text(value, style: const TextStyle(fontSize: 15),)),
      ],
    ),
  );
}
