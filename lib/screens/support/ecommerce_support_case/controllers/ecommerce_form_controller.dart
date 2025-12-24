import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class EcommerceFormController extends ChangeNotifier{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  String? selectedApp, selectedPriority = "Normal", selectedType;
  bool isLoading = false;


  void clearData() {
    title.clear();
    description.clear();
    selectedApp = null;
    selectedPriority = 'Normal';
    selectedType = null;
  }


  Future<void> submitForm(BuildContext context, AppLocalizations local, EcommerceProvider provider, int ensureUserId) async {
    final fileController = context.read<FileController>();

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
      ),
      fileController.attachedFiles,
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
