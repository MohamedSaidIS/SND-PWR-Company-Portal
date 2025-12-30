import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class VacationRequestFormScreen extends StatefulWidget {
  final String? personnelNumber;

  const VacationRequestFormScreen({super.key, required this.personnelNumber});

  @override
  State<VacationRequestFormScreen> createState() =>
      _VacationRequestFormScreenState();
}

class _VacationRequestFormScreenState extends State<VacationRequestFormScreen> {
 late final VacationRequestController controller;

  @override
  void initState() {
    super.initState();
   controller = VacationRequestController(context, personnelNumber: widget.personnelNumber);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RequestForm( controller: controller,),
      ),
    );
  }
}
