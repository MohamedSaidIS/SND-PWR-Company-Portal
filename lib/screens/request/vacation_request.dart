import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/export_import.dart';

class VacationRequestScreen extends StatelessWidget {
  const VacationRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VacationBalanceProvider>();
    final personnelNumber = provider.personnelNumber?.personnelNumber;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: CommonSupportAppbar(
        title: local.createRequest,
        tabTitle: local.createRequest,
        subTitle: local.previousRequests,
        tabBarChildren: [
          VacationRequestFormScreen(personnelNumber: personnelNumber),
          PreviousRequestScreen(personnelNumber: personnelNumber),
        ],
      ),
    );
  }
}
