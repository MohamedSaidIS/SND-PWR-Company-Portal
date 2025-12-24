import 'dart:convert';

import 'package:company_portal/models/local/attached_file_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class FileController extends ChangeNotifier {
  List<AttachedBytes> attachedFiles = [];

  void addFiles(List<AttachedBytes> files) {
    attachedFiles.addAll(files);
    notifyListeners();
  }

  void deleteFiles(int index) {
    attachedFiles.removeAt(index);
    notifyListeners();
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final newFiles = result.files.map((file) {
        return AttachedBytes(fileName: file.name, fileBytes: file.bytes!, fileBytesBase64: null, fileType: null);
      }).toList();

      addFiles(newFiles);
      notifyListeners();
    }
  }

  void clear() {
    attachedFiles.clear();
    notifyListeners();
  }

  Future<void> pickBase64Files() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final newFiles = result.files.map((file) {
        String fileType = "";
        if(file.extension == "png" || file.extension == "jpg"){
          fileType = "Image";
        }else if(file.extension == "pdf" || file.extension == "txt"){
          fileType = "File";
        }
        return AttachedBytes(
            fileName: file.name, fileBytesBase64: base64Encode(file.bytes!), fileBytes:  null, fileType: fileType);
      }).toList();

      addFiles(newFiles);
      notifyListeners();
    }
  }
}