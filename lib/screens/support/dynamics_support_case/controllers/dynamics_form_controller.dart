import 'package:company_portal/models/remote/dynamics_item.dart';
import 'package:company_portal/providers/dynamics_provider.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/app_notifier.dart';
import '../../../../utils/enums.dart';

class DynamicsFormController{
  BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  final area = TextEditingController();
  final date = TextEditingController();
  String? selectedPurpose, selectedPriority = 'Normal';
  bool isLoading = false;

  DynamicsFormController(this.context);

  void clearData(){
    title.clear();
    description.clear();
    area.clear();
    date.clear();
    selectedPurpose = null;
    selectedPriority = 'Normal';
  }

  Future<void> pickDate() async {
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

  Future<void> submitForm(AppLocalizations local, DynamicsProvider provider, int ensureUserId) async {
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
        )
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



  void dispose() {
    title.dispose();
    description.dispose();
  }


}