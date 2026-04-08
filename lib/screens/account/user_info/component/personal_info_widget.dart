import 'package:company_portal/screens/account/user_info/component/info_card.dart';
import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


class PersonalInfoWidget extends StatelessWidget {
   final UserInfo userInfo;

  const PersonalInfoWidget({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    final local = context.local;

    return InfoCard(children: [
      CardTitle(title: local.personalDetails),
      CardInfoRow(
        label: local.name, value: "${userInfo.givenName ?? "-"} ${userInfo.surname ?? "-"}", icon: LineAwesomeIcons.user,),
      CardInfoRow(
        label: local.phone, value: userInfo.mobilePhone ?? "-", icon: LineAwesomeIcons.phone_solid,),
      CardInfoRow(
        label: local.location, value: userInfo.officeLocation ?? "-", icon: LineAwesomeIcons.map_pin_solid,),
    ]);
  }
}
