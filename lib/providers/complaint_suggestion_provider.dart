import 'package:company_portal/data/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class ComplaintSuggestionProvider with ChangeNotifier {
  final SharePointDioClient sharePointDioClient;

  ComplaintSuggestionProvider({required this.sharePointDioClient});

  List<ComplaintSuggestionItem> _complaintSuggestionList = [];
  bool _loading = false;
  String? _error;

  List<ComplaintSuggestionItem>? get complaintSuggestionList =>
      _complaintSuggestionList;


  bool get loading => _loading;

  String? get error => _error;

  Future<void> getSuggestionsAndComplaints(int ensureUserId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.get(
          "/sites/IT-Requests/_api/Web/Lists(guid'${Constants.itListId}')/items?\$top=999");

      if (response.statusCode == 200) {
        final parsedResponse = response.data;

        _complaintSuggestionList = await compute(
          (final data) => (data['value'] as List)
              .map((e) => ComplaintSuggestionItem.fromJson(e as Map<String, dynamic>))
              .where((item) => item.authorId == ensureUserId)
              .toList(),
          parsedResponse
        );

        AppLogger.info("ComplaintSuggestion Provider",
            "ComplaintSuggestion Fetching: ${response.statusCode} ${_complaintSuggestionList[0].priority} ");
      } else {
        _error = 'Failed to load ComplaintSuggestion data';
        AppLogger.error("ComplaintSuggestion Provider",
            "ComplaintSuggestion Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error("ComplaintSuggestion Provider",
          "ComplaintSuggestion Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createSuggestionsAndComplaints(ComplaintSuggestionItem item, List<AttachedBytes> attachedFiles) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.post(
        "/sites/IT-Requests/_api/Web/Lists(guid'${Constants.itListId}')/items",
        data: item.toJson(),
      );

      if (response.statusCode == 201) {
        final ticket = await compute(
              (Map<String, dynamic> data) => ComplaintSuggestionItem.fromJson(data),
          Map<String, dynamic>.from(response.data),
        );
        AppLogger.info("ComplaintSuggestion Provider", "ComplaintSuggestion Send: Success ${response.statusCode}");
        await sendAttachments(attachedFiles, ticket.id);
        return true;
      } else {
        _error = 'Failed to send ComplaintSuggestion data';
        AppLogger.error("ComplaintSuggestion Provider",
            "ComplaintSuggestion Send Error:$_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error("ComplaintSuggestion Provider",
          "ComplaintSuggestion Send Exception: $_error");
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
      AppLogger.error(
          "ComplaintSuggestion Provider", "Send Attachments Exceptions: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  Future<bool> uploadSingleFile(String ticketId, AttachedBytes attachedFile) async {
    try {
      final response = await sharePointDioClient.dio.post(
        "https://alsanidi.sharepoint.com/sites/IT-Requests/_api/Web/Lists(guid'${Constants.itListId}')/items($ticketId)/AttachmentFiles/add(FileName='${attachedFile.fileName}')",
        data: attachedFile.fileBytes,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        AppLogger.info("ComplaintSuggestion Provider",
            "Send Attachments Success: ${response.statusCode}");
        return true;
      } else {
        AppLogger.error("ComplaintSuggestion Provider",
            "Send Attachments Failed: ${ response.statusCode}");
        return false;
      }
    } catch (e) {
      AppLogger.error(
          "ComplaintSuggestion Provider", "Upload Exception: ${e.toString()}");
      return false;
    }

  }
}
