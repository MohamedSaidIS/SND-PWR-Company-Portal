import 'package:company_portal/data/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';


class EcommerceProvider extends ChangeNotifier {
  final SharePointDioClient sharePointDioClient;

  EcommerceProvider({required this.sharePointDioClient});

  List<EcommerceItem> _ecommerceItemsList = [];

  bool _loading = false;
  String? _error;

  List<EcommerceItem> get ecommerceItemsList => _ecommerceItemsList;



  bool get loading => _loading;

  String? get error => _error;

  Future<void> getEcommerceItems(int ensureUserId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.get(
        "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'${Constants.alsanidiListId}')/items?\$top=999",
      );
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _ecommerceItemsList = await compute(
              (final data) =>
              (data['value'] as List)
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
      _ecommerceItemsList.isNotEmpty ?
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Ecommerce Fetching: ${response.statusCode} ${_ecommerceItemsList[0].app[0]}") :
      AppNotifier.logWithScreen("Ecommerce Provider",
          "Ecommerce Fetching: ${response.statusCode} ${_ecommerceItemsList.length}");

    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Ecommerce Provider", "Ecommerce Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createEcommerceItem(EcommerceItem item, List<AttachedBytes> attachedFiles) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.post(
        "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'${Constants.alsanidiListId}')/items",
        data: item.toJson(),
      );
      if (response.statusCode == 201) {
        final ticket = await compute(
              (Map<String, dynamic> data) => EcommerceItem.fromJson(data),
          Map<String, dynamic>.from(response.data),
        );
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Ecommerce Item Created: ${response.statusCode} ${ticket
                .id} ${ticket.title}");

        await sendAttachments(attachedFiles, ticket.id);

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

  Future<bool> sendAttachments(List<AttachedBytes> attachedFiles, int ticketId) async {
    _loading = true;
    _error = null;
    bool sendAttachedSuccessfully = false;
    try {
      for(var attachedFile in attachedFiles){
         sendAttachedSuccessfully = await uploadSingleFile(ticketId.toString(), attachedFile);
      }
     return sendAttachedSuccessfully;
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Ecommerce Provider", "Send Attachments Exceptions: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  Future<bool> uploadSingleFile(String ticketId, AttachedBytes attachedFile,) async {
    try {
      final response = await sharePointDioClient.dio.post(
        "https://alsanidi.sharepoint.com/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'${Constants.alsanidiListId}')/items($ticketId)/AttachmentFiles/add(FileName='${attachedFile.fileName}')",
        data: attachedFile.fileBytes,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Send Attachments Success: ${response.statusCode}");
        return true;
      } else {
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Send Attachments Failed: ${ response.statusCode}");
        return false;
      }
    } catch (e) {
      AppNotifier.logWithScreen(
          "Ecommerce Provider", "Upload Exception: ${e.toString()}");
      return false;
    }

  }



}
