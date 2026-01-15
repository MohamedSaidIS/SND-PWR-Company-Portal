import 'package:company_portal/screens/account/user_info/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:company_portal/utils/export_import.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

Widget buildPersonalCard(AppLocalizations local, UserInfo userInfo,){
  return UserInfoCard(children: [
    CardTitle(title: local.personalDetails),
    CardInfoRow(
      label: local.name, value: "${userInfo.givenName ?? "-"} ${userInfo.surname ?? "-"}", icon: LineAwesomeIcons.user,),
    CardInfoRow(
      label: local.phone, value: userInfo.mobilePhone ?? "-", icon: LineAwesomeIcons.phone_solid,),
    CardInfoRow(
      label: local.location, value: userInfo.officeLocation ?? "-", icon: LineAwesomeIcons.map_pin_solid,),
  ]);
}

Widget buildManagerCard(AppLocalizations local, UserInfo managerInfo,){
  return UserInfoCard(children: [
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
