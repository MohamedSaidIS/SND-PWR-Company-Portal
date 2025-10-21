import 'package:flutter/cupertino.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../providers/complaint_suggestion_provider.dart';
import '../../../../utils/app_notifier.dart';
import '../../../../utils/enums.dart';

class ComplaintSuggestionFormController {
  final BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final issueTitle = TextEditingController();
  final issueDescription = TextEditingController();

  String? selectedType = "Complaint";
  String? selectedCategory;
  String? selectedPriority = 'Normal';
  bool isChecked = true;
  bool isLoading = false;

  ComplaintSuggestionFormController(this.context, {required String userName}) {
    name.text = userName.trim();
  }

  void clearData() {
    name.clear();
    issueTitle.clear();
    issueDescription.clear();
    selectedCategory = null;
    selectedPriority = 'Normal';
  }

  Future<void> submitForm(AppLocalizations local,
      ComplaintSuggestionProvider provider, int ensureId) async {
    if (!formKey.currentState!.validate()) return;

    if (provider.loading) {
      AppNotifier.snackBar(context, "Please Wait", SnackBarType.info);
      return;
    }

    var success = await provider.createSuggestionsAndComplaints(
      issueTitle.text,
      issueDescription.text,
      selectedPriority!,
      selectedCategory!,
      isChecked ? name.text.trim() : '',
      ensureId,
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
    issueTitle.dispose();
    issueDescription.dispose();
    name.dispose();
  }
}
