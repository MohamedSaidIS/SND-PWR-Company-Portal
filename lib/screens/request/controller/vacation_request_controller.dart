import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import '../../../../utils/export_import.dart';

class VacationRequestController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String? personnelNumber;

  VacationRequestController(this.personnelNumber) {
    code.text = personnelNumber ?? "000000000";
  }

  bool isLoading = false;

  final management = TextEditingController();
  final department = TextEditingController();
  final code = TextEditingController();
  final name = TextEditingController();
  final jobTitle = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  String? vacationType;

  int calculateWorkingDays(DateTime start, DateTime end) {
    int workingDays = 0;
    for (DateTime date = start;
        !date.isAfter(end);
        date = date.add(const Duration(days: 1))) {
      // 5 = Friday, 6 = Saturday
      if (date.weekday != DateTime.friday &&
          date.weekday != DateTime.saturday) {
        workingDays++;
      }
    }
    return workingDays;
  }

  int get vacationDays {
    if (startDate == null || endDate == null) return 0;
    if (startDate == endDate) return 1;
    return calculateWorkingDays(startDate!, endDate!);
  }

  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Future<void> pickDate(BuildContext context, bool isStart) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate ?? initialDate : endDate ?? initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      if (isStart) {
        startDate = newDate;
        if (endDate != null && endDate!.isBefore(startDate!)) {
          endDate = null;
        }
      } else {
        endDate = newDate;
      }
      notifyListeners();
    }
  }

  String formatDate(DateTime? date, AppLocalizations local, String locale) {
    if (date == null) return local.selectDate;
    return DateFormat('dd-MM-yyyy', locale).format(date);
  }

  void submitRequest(BuildContext context, AppLocalizations local) {
    final isValid = formKey.currentState?.validate() ?? false;
    if (isValid && startDate != null && endDate != null) {
      AppNotifier.snackBar(
          context, local.vacationRequestSubmitted, SnackBarType.warning);
      return;
    } else {
      AppNotifier.snackBar(
          context, local.pleaseFillAllFields, SnackBarType.warning);
      return;
    }
  }

  @override
  void dispose() {
    management.dispose();
    department.dispose();
    code.dispose();
    name.dispose();
    jobTitle.dispose();
    super.dispose();
  }
}
