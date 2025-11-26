import 'package:company_portal/screens/support/ecommerce_support_case/controllers/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';


class DynamicsFormController extends ChangeNotifier{

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  final area = TextEditingController();
  final date = TextEditingController();
  String? selectedPurpose, selectedPriority = 'Normal';
  bool isLoading = false;


  void clearData(){
    title.clear();
    description.clear();
    area.clear();
    date.clear();
    selectedPurpose = null;
    selectedPriority = 'Normal';
  }

  Future<void> pickDate(BuildContext context,) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      date.text =
          DateFormat('dd-MM-yyyy', context.currentLocale()).format(picked);
    }
  }

  Future<void> submitForm(BuildContext context, AppLocalizations local, DynamicsProvider provider, int ensureUserId) async {
    final fileController = context.read<FileController>();
    if (!formKey.currentState!.validate()) return;


    if (provider.loading) {
      AppNotifier.snackBar(context, "Please Wait", SnackBarType.info);
      return;
    }
     final parsed = DateFormat('dd-MM-yyyy').parse(date.text);
    var success = await provider.createDynamicsItem(
        DynamicsItem(
          id: -1,
          title: title.text,
          description: description.text,
          priority: selectedPriority!,
          status: "New",
          authorId: ensureUserId,
          createdDate: null,
          modifiedDate: null,
          area: area.text,
          purpose: selectedPurpose!,
          dateReported: parsed,
        ),
      fileController.attachedFiles ,
    );

    if (success) {
      clearData();
      fileController.clear();
      AppNotifier.snackBar(
        context,
        local.fromSubmittedSuccessfully,
        SnackBarType.success,
      );
    }
  }



  void dispose() {
    title.dispose();
    description.dispose();
  }


}