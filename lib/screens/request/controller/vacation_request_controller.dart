import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import '../../../../utils/export_import.dart';

class VacationRequestController  {
  BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String? personnelNumber;

  final management = TextEditingController();
  final department = TextEditingController();
  final code = TextEditingController();
  final jobTitle = TextEditingController();
  final note = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  bool startDateSelected = true,
      endDateSelected = true;
  bool isLoading = false;

  String? vacationType;
  String? selectedType = "Vacation";

  VacationRequestController(this.context, {required this.personnelNumber}) {
    code.text = personnelNumber ?? "000000000";
  }

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

  Future<void> pickDateTime(BuildContext context, bool isStartDate) async {
    final theme = Theme.of(context);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate:
      isStartDate ? startDate ?? DateTime.now() : endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate == null) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;
    final fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    if (isStartDate) {
      startDate = fullDateTime;
    } else {
      endDate = fullDateTime;
    }
  }



  Future<void> submitRequest(BuildContext context,
      AppLocalizations local) async {
    final provider = context.read<VacationPermissionRequestProvider>();
    final fileController = context.read<FileController>();

    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (startDate == null || endDate == null) {
      AppNotifier.snackBar(context, local.selectDate, SnackBarType.error);
      isLoading = false;
    }

    if (startDate != null && endDate != null && startDate!.isAfter(endDate!)) {
      AppNotifier.snackBar(
          context, local.startDateCannotBeAfterEndDate, SnackBarType.error);
      isLoading = false;
    }

    if (provider.loading) {
      AppNotifier.snackBar(context, "Please Wait", SnackBarType.info);
      return;
    }
    if (startDate != null || endDate != null) {
      var success = await provider.createRequest(
        selectedType!,
        VacationPermissionRequest(
          startDate: startDate!,
          endDate: endDate!,
          personnelNumber: code.text,
          absenceCode: vacationType!,
          notes: note.text,
          attachments: vacationType == "001" ? getAttachments(fileController.attachedFiles) : null,
        ),
      );

      if (success) {
        clearData();
        AppNotifier.snackBar(
          context,
          local.fromSubmittedSuccessfully,
          SnackBarType.success,
        );
      }
    }
  }

  List<VacationAttachment> getAttachments(List<AttachedBytes> attachedFiles) {
    // print("Base64Files ${attachedFiles.first.fileName} ${attachedFiles.first.fileBytesBase64}");
    return attachedFiles.map((attachment) {
      return VacationAttachment(
          fileNameWithExtension: attachment.fileName,
          fileType: attachment.fileType?? "",
          file: attachment.fileBytesBase64!);
    }).toList();

  }

  void clearData() {
    management.clear();
    department.clear();
    jobTitle.clear();
    vacationType = null;
    selectedType = 'Vacation';
    startDate = null;
    endDate = null;
  }

  void dispose() {
    management.dispose();
    department.dispose();
    code.dispose();
    jobTitle.dispose();
  }
}
