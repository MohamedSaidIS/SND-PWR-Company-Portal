import 'dart:io';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHandler {
  final BuildContext context;
  final ImagePicker _picker = ImagePicker();

  ImagePickerHandler(this.context);

  Future<void> showPicker(Function(File) onImagePicked) async {
    final theme = context.theme;
    final local = context.local;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(local.takePhoto),
                onTap: () => _pickImage(ImageSource.camera, onImagePicked),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(local.chooseFromGallery),
                onTap: () => _pickImage(ImageSource.gallery, onImagePicked),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.close, color: theme.colorScheme.secondary,),
                title: Text(local.cancel, style: TextStyle(color: theme.colorScheme.secondary)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(
      ImageSource source, Function(File) onImagePicked) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
    Navigator.pop(context);
  }
}
