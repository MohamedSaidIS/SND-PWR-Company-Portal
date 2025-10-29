import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';


class UserInfoDetailsScreen extends StatefulWidget {
  const UserInfoDetailsScreen(
      {super.key,
        required this.userName,
        required this.userPhone,
        required this.userOfficeLocation});

  final String userName, userPhone, userOfficeLocation;

  @override
  State<UserInfoDetailsScreen> createState() => _UserInfoDetailsScreenState();
}

class _UserInfoDetailsScreenState extends State<UserInfoDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    final managerInfoProvider = context.watch<ManagerInfoProvider>();
    final managerInfo = managerInfoProvider.managerInfo;
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.userInfo,
          backBtn: true,
        ),
        body: managerInfoProvider.loading
            ? const Center(child: CircularProgressIndicator())
            : managerInfoProvider.error != null
            ? Center(child: Text("Error: ${managerInfoProvider.error}"))
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                buildInfoCard([
                  buildSectionTitle(
                      local.personalDetails, context, theme),
                  buildInfoRow(
                    local.name,
                    widget.userName,
                    LineAwesomeIcons.user,
                    theme,
                  ),
                  buildInfoRow(
                    local.phone,
                    widget.userPhone,
                    LineAwesomeIcons.phone_solid,
                    theme,
                  ),
                  buildInfoRow(
                      local.location,
                      widget.userOfficeLocation,
                      LineAwesomeIcons.map_pin_solid,
                      theme),
                ], theme),
                const SizedBox(height: 20),
                buildInfoCard([
                  buildSectionTitle(local.managerDetails, context, theme),
                  buildInfoRow(
                      local.name,
                      "${managerInfo?.givenName ?? "-"} ${managerInfo?.surname ?? "-"}",
                      LineAwesomeIcons.user,
                      theme),
                  buildInfoRow(
                      local.jobTitle,
                      managerInfo?.jobTitle ?? "-",
                      Icons.work_outline,
                      theme),
                  buildInfoRow(
                    local.email,
                    managerInfo?.mail ?? "-",
                    LineAwesomeIcons.mail_bulk_solid,
                    theme,
                  ),
                  buildInfoRow(
                    local.phone,
                    managerInfo?.mobilePhone ?? "-",
                    LineAwesomeIcons.phone_solid,
                    theme,
                  ),
                  buildInfoRow(
                      local.location,
                      managerInfo?.officeLocation ?? "-",
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


