import 'package:company_portal/l10n/app_localizations.dart';
import 'package:company_portal/models/remote/e_commerce_item.dart';
import 'package:company_portal/providers/e_commerce_provider.dart';
import 'package:flutter/material.dart';

import '../../../../utils/app_notifier.dart';
import '../../../../utils/enums.dart';

class EcommerceFormController {
  final BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  String? selectedApp, selectedPriority = "Normal", selectedType;
  bool isLoading = false;

  EcommerceFormController(this.context,);

  void clearData() {
    title.clear();
    description.clear();
    selectedApp = null;
    selectedPriority = 'Normal';
  }

  Future<void> submitForm(AppLocalizations local, EcommerceProvider provider,
      int ensureUserId) async {
    if (!formKey.currentState!.validate()) return;

    if (provider.loading) {
      AppNotifier.snackBar(context, "Please Wait", SnackBarType.info);
      return;
    }

    var success = await provider.createEcommerceItem(
        EcommerceItem(
          id: -1,
          title: title.text,
          description: description.text,
          priority: selectedPriority,
          status: "New",
          assignedToId: null,
          authorId: ensureUserId,
          createdDate: null,
          modifiedDate: null,
          issueLoggedById: null,
          type: selectedType,
          app: [selectedApp!],
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
