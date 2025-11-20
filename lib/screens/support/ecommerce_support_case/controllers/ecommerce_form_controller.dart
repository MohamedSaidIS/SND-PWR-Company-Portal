import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class EcommerceFormController {
  final BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  String? selectedApp, selectedPriority = "Normal", selectedType;
  bool isLoading = false;
  String fileName = '';      // "document.pdf"
  String? filePath;

  EcommerceFormController(
    this.context,
  );

  void clearData() {
    title.clear();
    description.clear();
    selectedApp = null;
    selectedPriority = 'Normal';
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;

      fileName = file.name;      // "document.pdf"
      filePath = file.path;     // "/storage/.../document.pdf"

      print("Picked file name: $fileName");
      print("Picked file path: $filePath");

      final fileObject = File(filePath!);
    } else {
      print("User canceled file picking");
    }
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
      ),
      File(filePath!),
      fileName
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
