import 'package:company_portal/screens/support/ecommerce_support_case/controllers/file_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class ComplaintSuggestionFormController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final issueTitle = TextEditingController();
  final issueDescription = TextEditingController();

  String? selectedType = "Complaint";
  String? selectedCategory;
  String? selectedPriority = 'Normal';
  bool isChecked = true;
  bool isLoading = false;

  void setUserName(String userName) {
    if (name.text == userName) return;
    name.text = userName.trim();
    notifyListeners();
  }

  void clearData() {
    name.clear();
    issueTitle.clear();
    issueDescription.clear();
    selectedCategory = null;
    selectedPriority = 'Normal';
  }

  Future<void> submitForm(BuildContext context, AppLocalizations local,
      ComplaintSuggestionProvider provider, int ensureId) async {
    final fileController = context.read<FileController>();
    if (!formKey.currentState!.validate()) return;

    print("EnsureId: $ensureId");

    if (provider.loading) {
      AppNotifier.snackBar(context, "Please Wait", SnackBarType.info);
      return;
    }

    var success = await provider.createSuggestionsAndComplaints(
        ComplaintSuggestionItem(
          id: -1,
          title: issueTitle.text,
          description: issueDescription.text,
          priority: selectedPriority!,
          status: "New",
          department: selectedCategory,
          createdDate: null,
          modifiedDate: null,
          assignedToId: null,
          authorId: ensureId,
          issueLoggedById: ensureId,
          issueLoggedByName: isChecked ? name.text.trim() : '',
        ),
        fileController.attachedFiles);

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
    issueTitle.dispose();
    issueDescription.dispose();
    name.dispose();
  }
}
