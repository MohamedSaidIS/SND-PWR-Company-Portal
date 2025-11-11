import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/export_import.dart';

class VacationRequestScreen extends StatefulWidget {
  const VacationRequestScreen({super.key});

  @override
  State<VacationRequestScreen> createState() => _VacationRequestScreenState();
}

class _VacationRequestScreenState extends State<VacationRequestScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VacationBalanceProvider>();
    final personnelNumber = provider.personnelNumber?.personnelNumber;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: CommonSupportAppbar(
        title: local.vacationRequestLine,
        tabTitle: local.vacationRequestLine,
        subTitle: "Previous Requests",
        tabBarChildren: [
          VacationRequestFormScreen(personnelNumber: personnelNumber),
          const PreviousRequestScreen(),
        ],
      ),
    );
  }
}
