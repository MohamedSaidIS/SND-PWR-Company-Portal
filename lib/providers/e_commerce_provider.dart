import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';


class EcommerceProvider extends ChangeNotifier {
  final SharePointDioClient sharePointDioClient;

  EcommerceProvider({required this.sharePointDioClient});

  List<EcommerceItem> _ecommerceItemsList = [];
  Uint8List? _fetchedImageBytes;
  bool _loading = false;
  String? _error;

  List<EcommerceItem> get ecommerceItemsList => _ecommerceItemsList;
  Uint8List? get imageBytes => _fetchedImageBytes;
  bool get loading => _loading;

  String? get error => _error;

  Future<void> getEcommerceItems(int ensureUserId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.get(
        "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'c09e3694-3b81-43b5-b39c-49a26155612e')/items?\$top=999",
      );
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _ecommerceItemsList = await compute(
          (final data) => (data['value'] as List)
              .map((e) => EcommerceItem.fromJson(e as Map<String, dynamic>))
              .where((item) => item.authorId == ensureUserId)
              .toList(),
          parsedResponse,
        );
      } else {
        _error = 'Failed to load Ecommerce data';
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Ecommerce Error: $_error ${response.statusCode}");
      }
      _ecommerceItemsList.isNotEmpty
          ? AppNotifier.logWithScreen("Ecommerce Provider",
              "Ecommerce Fetching: ${response.statusCode} ${_ecommerceItemsList[0].app[0]}")
          : AppNotifier.logWithScreen("Ecommerce Provider",
              "Ecommerce Fetching: ${response.statusCode} ${_ecommerceItemsList.length}");
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Ecommerce Provider", "Ecommerce Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createEcommerceItem(EcommerceItem item, File attachedFile, String fileName) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.post(
        "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'c09e3694-3b81-43b5-b39c-49a26155612e')/items",
        data: item.toJson(),
      );
      if (response.statusCode == 201) {
        final ticket = await compute(
          (Map<String, dynamic> data) => EcommerceItem.fromJson(data),
          Map<String, dynamic>.from(response.data),
        );
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Ecommerce Item Created: ${response.statusCode} ${ticket.id} ${ticket.title}");
        
        await sendAttachments(attachedFile, ticket.id, fileName);
        
        return true;
      } else {
        _error = 'Failed to load Ecommerce data';
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Ecommerce Item Error: $_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Ecommerce Provider", "Ecommerce Item Exception: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  Future<bool> sendAttachments(File attachedFile, int ticketId, String fileName) async{
    _loading = true;
    _error = null;
    final bytes = await attachedFile.readAsBytes();
    try{
      final response = await sharePointDioClient.dio.post(
          "https://alsanidi.sharepoint.com/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'c09e3694-3b81-43b5-b39c-49a26155612e')/items($ticketId)/AttachmentFiles/add(FileName='$fileName')",
        data: bytes,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );
      if(response.statusCode == 200){
        AppNotifier.logWithScreen("Ecommerce Provider", "Send Attachments Success: ${response.statusCode}");
        return true;
      }else{
        AppNotifier.logWithScreen("Ecommerce Provider", "Send Attachments Failed: ${response.statusCode}");
        return false;
      }
    }catch(e){
      _error = e.toString();
      AppNotifier.logWithScreen("Ecommerce Provider", "Send Attachments Exceptions: $_error");
      return false;
    }finally{
      _loading = false;
      notifyListeners();
    }
  }


  Future<void> fetchImage() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.dio.get(
        "https://alsanidi.sharepoint.com/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'c09e3694-3b81-43b5-b39c-49a26155612e')//items(206)/AttachmentFiles('Screenshot_20250319-115346.png')/\$value",
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Content-Type': 'image/jpeg',
          },
        ),
      );

      if (response.statusCode == 200) {
        _fetchedImageBytes = Uint8List.fromList(response.data);
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Ecommerce Image Fetching Success: $_fetchedImageBytes");
      } else if (response.statusCode == 401) {
        _error = response.statusMessage.toString();
      } else {
        _error = 'Failed to load Ecommerce image';
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Ecommerce Image Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      AppNotifier.logWithScreen(
          "Ecommerce Provider", "Ecommerce Image Exception: ${e.toString()}");
    }

    _loading = false;
    notifyListeners();
  }

}
