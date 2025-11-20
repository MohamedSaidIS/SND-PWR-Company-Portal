import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../utils/export_import.dart';


class DynamicsFormController{
  BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  final area = TextEditingController();
  final date = TextEditingController();
  String? selectedPurpose, selectedPriority = 'Normal';
  bool isLoading = false;
  String fileName = '';      // "document.pdf"
  String? filePath;

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
        ),
        File(filePath!),
        fileName,
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