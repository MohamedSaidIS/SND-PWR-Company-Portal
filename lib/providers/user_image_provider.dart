import 'dart:io';
import 'dart:typed_data';
import 'package:company_portal/service/graph_dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utils/app_notifier.dart';

class UserImageProvider extends ChangeNotifier {
  final GraphDioClient dioClient;

  UserImageProvider({required this.dioClient});

  Uint8List? _fetchedImageBytes;
  File? _pickedImage;
  bool _loading = false;
  bool _isUploading = false;
  String? _error;

  Uint8List? get imageBytes => _fetchedImageBytes;

  bool get loading => _loading;

  bool get isUploading => _isUploading;

  File? get pickedImage => _pickedImage;

  String? get error => _error;

  Future<void> fetchImage() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.dio.get(
        '/me/photo/\$value',
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Content-Type': 'image/jpeg',
          },
        ),
      );

      if (response.statusCode == 200) {
        _fetchedImageBytes = Uint8List.fromList(response.data);
        AppNotifier.logWithScreen("User Image Provider",
            "User Image Fetching Success: $_fetchedImageBytes");
      } else if (response.statusCode == 401) {
        _error = response.statusMessage.toString();
      } else {
        _error = 'Failed to load user image';
        AppNotifier.logWithScreen("User Image Provider",
            "User Image Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      AppNotifier.logWithScreen(
          "User Image Provider", "User Image Exception: ${e.toString()}");
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> uploadImage(File imageFile) async {
    _isUploading = true;
    _error = null;
    _pickedImage = imageFile;
    notifyListeners();

    try {
      final imageBytes = await imageFile.readAsBytes();

      final response = await dioClient.dio.put('/me/photo/\$value',
          data: imageBytes,
          options: Options(
            headers: {
              'Content-Type': 'image/jpeg',
            },
          ));

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppNotifier.logWithScreen("User Image Provider",
            "Upload Image Success: Photo updated Successfully");
        return true;
      } else {
        _error = 'Failed to upload image to server';
        AppNotifier.logWithScreen("User Image Provider",
            "Upload Image Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      AppNotifier.logWithScreen(
          "User Image Provider", "Upload Image Exception: ${e.toString()}");
    }
    _isUploading = false;
    notifyListeners();
    return false;
  }
}
