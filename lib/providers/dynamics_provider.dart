import 'package:company_portal/data/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class DynamicsProvider extends ChangeNotifier {
  final MySharePointDioClient mySharePointDioClient;

  DynamicsProvider({required this.mySharePointDioClient});

  List<DynamicsItem> _dynamicsItemsList = [];
  bool _loading = false;
  String? _error;

  List<DynamicsItem> get dynamicsItemsList => _dynamicsItemsList;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> getDynamicsItems(int ensureUserId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await mySharePointDioClient.get(
        "/_api/Web/Lists(guid'${Constants.dynamicsListId}')/items?\$top=2999",
      );
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _dynamicsItemsList = await compute(
          (final data) => (data['value'] as List)
              .map((e) => DynamicsItem.fromJson(e as Map<String, dynamic>))
              .where((item) => item.authorId == ensureUserId)
              .toList(),
          parsedResponse,
        );
      } else {
        _error = 'Failed to load Dynamics data';
        AppNotifier.logWithScreen("Dynamics Provider",
            "Dynamics Error: $_error ${response.statusCode}");
      }
      _dynamicsItemsList.isNotEmpty
          ? AppNotifier.logWithScreen("Dynamics Provider",
              "Dynamics Fetching: ${response.statusCode} ${_dynamicsItemsList[0].area}")
          : AppNotifier.logWithScreen("Dynamics Provider",
              "Dynamics Fetching: ${response.statusCode} ${_dynamicsItemsList.length}");
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Dynamics Provider", "Dynamics Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createDynamicsItem(
      DynamicsItem item, List<AttachedBytes> attachedFiles) async {
    _loading = true;
    _error = null;
    notifyListeners();
    debugPrint("Dynamics Item ${item.toJson()}");

    try {
      final response = await mySharePointDioClient.post(
        "/_api/Web/Lists(guid'${Constants.dynamicsListId}')/items",
        data: item.toJson(),
      );
      if (response.statusCode == 201) {
        final ticket = await compute(
          (Map<String, dynamic> data) => DynamicsItem.fromJson(data),
          Map<String, dynamic>.from(response.data),
        );
        AppNotifier.logWithScreen("Dynamics Provider",
            "Dynamics Item Created: ${response.statusCode} ${ticket.id}");

        await sendAttachments(attachedFiles, ticket.id);
        return true;
      } else {
        _error = 'Failed to load Dynamics data';
        AppNotifier.logWithScreen("Dynamics Provider",
            "Dynamics Item Error: $_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Dynamics Provider", "Dynamics Item Exception: $_error");
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
      for (var attachedFile in attachedFiles) {
        sendAttachedSuccessfully =
            await uploadSingleFile(ticketId.toString(), attachedFile);
      }
      return sendAttachedSuccessfully;
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Dynamics Provider", "Send Attachments Exceptions: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> uploadSingleFile(
    String ticketId,
    AttachedBytes attachedFile,
  ) async {
    try {
      final response = await mySharePointDioClient.dio.post(
        "https://alsanidi-my.sharepoint.com/personal/retail_alsanidi_onmicrosoft_com/_api/Web/Lists(guid'${Constants.dynamicsListId}')/items($ticketId)/AttachmentFiles/add(FileName='${attachedFile.fileName}')",
        data: attachedFile.fileBytes,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );
      if(response.statusCode == 200){
        AppNotifier.logWithScreen("Dynamics Provider", "Send Attachments Success: ${response.statusCode}");
        return true;
      }else{
        AppNotifier.logWithScreen("Dynamics Provider", "Send Attachments Failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      AppNotifier.logWithScreen(
          "Ecommerce Provider", "Upload Exception: ${e.toString()}");
      return false;
    }
  }
}
