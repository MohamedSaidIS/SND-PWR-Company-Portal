import 'dart:typed_data';

import 'package:company_portal/models/local/attached_file_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class EcommerceFormController extends ChangeNotifier{
  final BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  String? selectedApp, selectedPriority = "Normal", selectedType;
  bool isLoading = false;
  List<Uint8List> allFilesBytes = [];
  List<String> allFilesNames = [];
  List<AttachedBytes> allFilesAttached = [];

  EcommerceFormController(
    this.context,
  );

  void clearData() {
    title.clear();
    description.clear();
    selectedApp = null;
    selectedPriority = 'Normal';
  }


  void addFiles(List<AttachedBytes> files) {
    allFilesAttached.addAll(files);
    notifyListeners();
  }

  void deleteFiles(int index) {
    allFilesAttached.removeAt(index);
    notifyListeners();
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final newFiles = result.files.map((file) {
        allFilesNames.add(file.name);
        allFilesBytes.add(file.bytes!);
        return AttachedBytes(fileName: file.name, fileBytes: file.bytes!);
      }).toList();

      addFiles(newFiles);
      notifyListeners();
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
      allFilesAttached,
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
