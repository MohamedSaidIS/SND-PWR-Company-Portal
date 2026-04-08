import 'package:company_portal/screens/account/user_info/component/info_card.dart';
import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ManagerInfoWidget extends StatelessWidget {
  final UserInfo managerInfo;

  const ManagerInfoWidget({super.key, required this.managerInfo});

  @override
  Widget build(BuildContext context) {
    final local = context.local;

    return InfoCard(children: [
      CardTitle(title: local.managerDetails,),
      CardInfoRow(
        label: local.name,
        value: "${managerInfo.givenName ?? "-"} ${managerInfo.surname ?? "-"}",
        icon: LineAwesomeIcons.user,
      ),
      CardInfoRow(
        label: local.jobTitle,
        value: managerInfo.jobTitle ?? "-",
        icon: Icons.work_outline,
      ),
      CardInfoRow(
        label: local.email,
        value: managerInfo.mail ?? "-",
        icon: LineAwesomeIcons.mail_bulk_solid,
      ),
      CardInfoRow(
        label: local.phone,
        value: managerInfo.mobilePhone ?? "-",
        icon: LineAwesomeIcons.phone_solid,
      ),
      CardInfoRow(
        label: local.location,
        value: managerInfo.officeLocation ?? "-",
        icon: LineAwesomeIcons.map_pin_solid,
      ),
    ]);
  }
}
