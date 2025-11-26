import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class AttachmentsProvider extends ChangeNotifier {
  final SharePointDioClient sharePointDioClient;
  final MySharePointDioClient mySharePointDioClient;

  AttachmentsProvider(
      {required this.sharePointDioClient, required this.mySharePointDioClient});

  static const itListId = '35274cd8-ad05-4d42-adc1-20a127aad3d3';
  static const alsanidiListId = 'c09e3694-3b81-43b5-b39c-49a26155612e';
  static const dynamicsListId = '3b2e2dd6-55a0-4ee4-b517-5ccd63b6a12a';

  List<Attachment> _attachments = [];
  List<AttachedBytes> _fetchedFileBytes = [];
  bool _loading = false;
  String? _error;

  List<Attachment> get attachments => _attachments;

  List<AttachedBytes>? get fileBytes => _fetchedFileBytes;

  bool get loading => _loading;

  String? get error => _error;

  String retrieveUrl(String ticketId, String commentCall) {
    var url =
        "/sites/IT-Requests/_api/web/lists(guid'$itListId')/items($ticketId)/AttachmentFiles";
    switch (commentCall) {
      case "It":
        url =
            "/sites/IT-Requests/_api/web/lists(guid'$itListId')/items($ticketId)/AttachmentFiles";
        break;
      case "Alsanidi":
        url =
            "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'$alsanidiListId')/items($ticketId)/AttachmentFiles";
        break;
      case "Dynamics":
        url =
            "https://alsanidi-my.sharepoint.com/personal/retail_alsanidi_onmicrosoft_com/_api/Web/Lists(guid'$dynamicsListId')/items($ticketId)/AttachmentFiles";
        break;
    }
    return url;
  }

  Future<void> getAttachments(String ticketId, String commentCall) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final url = retrieveUrl(ticketId, commentCall);
    debugPrint("Get Url $url");

    try {
      final response = (commentCall == " Dynamics")
          ? await mySharePointDioClient.dio.get(url)
          : await sharePointDioClient.dio.get(url);

      if (response.statusCode == 200) {
        final parsedResponse = response.data["value"];
        AppNotifier.logWithScreen(
            "Attachment Provider", "Attachments Fetching: $parsedResponse");

        _attachments = await compute(
          (final data) => (data as List)
              .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList(),
          parsedResponse,
        );
        List<String> fileNames = _attachments.map((e) => e.fileName).toList();
        print("FileNames: $fileNames");
        await fetchAttachedFiles(ticketId, fileNames, commentCall);

        AppNotifier.logWithScreen("Attachment Provider",
            "Attachments Fetching parsed: ${attachments[0].fileName}");
      } else {
        _error = 'Failed to load Attachments data';
        AppNotifier.logWithScreen(
            "Attachments Error: ", "$_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Attachment Provider", "Attachments Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  String retrieveAttachedFileUrl(
      String ticketId, String commentCall, String fileName) {
    var url =
        "/sites/IT-Requests/_api/web/lists(guid'$itListId')//items($ticketId)/AttachmentFiles('$fileName')/\$value";
    switch (commentCall) {
      case "It":
        url =
            "/sites/IT-Requests/_api/web/lists(guid'$itListId')//items($ticketId)/AttachmentFiles('$fileName')/\$value";
        break;
      case "Alsanidi":
        url =
            "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'$alsanidiListId')//items($ticketId)/AttachmentFiles('$fileName')/\$value";
        break;
      case "Dynamics":
        url =
            "https://alsanidi-my.sharepoint.com/personal/retail_alsanidi_onmicrosoft_com/_api/Web/Lists(guid'$dynamicsListId')//items($ticketId)/AttachmentFiles('$fileName')/\$value";
        break;
    }
    return url;
  }

  Future<Uint8List?> downloadSingleFile(
    String ticketId,
    String fileName,
    String commentCall,
  ) async {
    final url = retrieveAttachedFileUrl(ticketId, commentCall, fileName);
    debugPrint("Get Url $url");

    try {
      final response = (commentCall == " Dynamics")
          ? await mySharePointDioClient.dio.get(
              url,
              options: Options(
                responseType: ResponseType.bytes,
              ),
            )
          : await sharePointDioClient.dio.get(
              url,
              options: Options(
                responseType: ResponseType.bytes,
              ),
            );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      }
    } catch (e) {
      AppNotifier.logWithScreen(
          "Ecommerce Provider", "Download Exception: ${e.toString()}");
    }
    return null;
  }

  Future<void> fetchAttachedFiles(String ticketId, List<String> fileNames, String commentCall) async {
    _loading = true;
    _error = null;
    _fetchedFileBytes = [];
    notifyListeners();

    try {
      for (String fileName in fileNames) {
        Uint8List? fileBytes = await downloadSingleFile(ticketId, fileName, commentCall);

        if (fileBytes != null) {
          _fetchedFileBytes.add(AttachedBytes(fileName: fileName, fileBytes: fileBytes));

          AppNotifier.logWithScreen(
            "Ecommerce Provider",
            "Fetched File: $fileName | Size: ${fileBytes.lengthInBytes} bytes | Length: ${_fetchedFileBytes.length} | AttachedItem ${_fetchedFileBytes[0].fileName}",
          );
        }
      }
      if (_fetchedFileBytes.isEmpty) {
        _error = "No files fetched";
      }
    } catch (e) {
      AppNotifier.logWithScreen(
          "Ecommerce Provider", "Ecommerce Image Exception: ${e.toString()}");
    }

    _loading = false;
    notifyListeners();
  }
}


