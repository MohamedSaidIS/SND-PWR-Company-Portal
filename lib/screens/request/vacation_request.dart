import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/custom_app_bar.dart';
import '../../l10n/app_localizations.dart';
import 'package:signature/signature.dart';

class VacationRequestScreen extends StatefulWidget {
  const VacationRequestScreen({super.key});

  @override
  State<VacationRequestScreen> createState() => _VacationRequestScreenState();
}

class _VacationRequestScreenState extends State<VacationRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController managementCtrl = TextEditingController();
  final TextEditingController departmentCtrl = TextEditingController();
  final TextEditingController codeCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController jobTitleCtrl = TextEditingController();
  final TextEditingController vacationTypeCtrl = TextEditingController();


  DateTime? startDate;
  DateTime? endDate;

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

  Future<void> pickDate(bool isStart) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate ?? initialDate : endDate ?? initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        if (isStart) {
          startDate = newDate;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        } else {
          endDate = newDate;
        }
      });
    }
  }

  String formatDate(DateTime? date, AppLocalizations local) {
    if (date == null) return local.selectDate;
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void submitRequest(AppLocalizations local) {
    if (_formKey.currentState!.validate() &&
        startDate != null &&
        endDate != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.vacationRequestSubmitted)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.pleaseFillAllFields)),
      );
    }
  }

  @override
  void dispose() {
    managementCtrl.dispose();
    departmentCtrl.dispose();
    codeCtrl.dispose();
    nameCtrl.dispose();
    jobTitleCtrl.dispose();
    vacationTypeCtrl.dispose();
    signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final alignment = context.alignment;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.vacationRequestLine,
          backBtn: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(local.managementName, managementCtrl, theme, local),
                _buildTextField(local.departmentName, departmentCtrl, theme, local),
                _buildTextField(local.employeeCode, codeCtrl, theme, local),
                _buildTextField(local.employeeName, nameCtrl, theme, local),
                _buildTextField(local.jobTitle, jobTitleCtrl, theme, local),
                _buildTextField(local.vacationType, vacationTypeCtrl, theme, local),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => pickDate(true),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          alignment: alignment,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: _buildDateText(local.startDate, formatDate(startDate, local), theme)
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => pickDate(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          alignment: alignment,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: _buildDateText(local.endDate, formatDate(endDate,local), theme),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${local.vacationDays}: $vacationDays',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(local.signature, style: theme.textTheme.displayMedium),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.primary,),
                  ),
                  child: Signature(
                    controller: signatureController,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                OutlinedButton(
                  onPressed: () => signatureController.clear(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child:  Text(local.clearSignature, style: TextStyle(fontSize: 16, color: theme.colorScheme.secondary),),
                ),
                const SizedBox(height: 5),
                _buildSubmitButton(local.submitRequest, theme, () => submitRequest(local)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField(String label, TextEditingController controller, ThemeData theme, AppLocalizations local) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
      value == null || value.isEmpty ? local.requiredField : null,
    ),
  );
}

Widget _buildSubmitButton(String btnText, ThemeData theme, void Function() btnFunction) {
  return ElevatedButton(
    onPressed: btnFunction,
    style: ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.secondary ,
      foregroundColor: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    child: Text(btnText, style: TextStyle(fontSize: 16, color: theme.colorScheme.surface),),
  );
}

Widget _buildDateText(String dateText, String formatDate, ThemeData theme) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        dateText,
        style: theme.textTheme.titleMedium,
      ),
      const SizedBox(
        height: 3,
      ),
      Text(
        formatDate,
        style: theme.textTheme.titleSmall,
      ),
    ],
  );
}
