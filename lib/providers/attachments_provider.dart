import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class AttachmentsProvider extends ChangeNotifier {
  final SharePointDioClient sharePointDioClient;
  final MySharePointDioClient mySharePointDioClient;

  AttachmentsProvider({required this.sharePointDioClient, required this.mySharePointDioClient});


  List<Attachment> _attachments = [];
  List<AttachedBytes> _fetchedFileBytes = [];
  bool _loading = false;
  String? _error;

  List<Attachment> get attachments => _attachments;

  List<AttachedBytes>? get fileBytes => _fetchedFileBytes;

  bool get loading => _loading;

  String? get error => _error;

  String retrieveUrl(String ticketId, String commentCall) {
    var url = ShareApiConfig.complaintAttachments(ticketId: ticketId);

    switch (commentCall) {
      case "It":
        url = ShareApiConfig.complaintAttachments(ticketId: ticketId);
        break;
      case "Alsanidi":
        url = ShareApiConfig.ecommerceAttachments(ticketId: ticketId);
        break;
      case "Dynamics":
        url = MyShareApiConfig.dynamicAttachments(ticketId: ticketId);
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
          ? await mySharePointDioClient.get(url)
          : await sharePointDioClient.get(url);

      if (response.statusCode == 200) {
        final parsedResponse = response.data["value"];
        AppLogger.info(
            "Attachment Provider", "Attachments Fetching: $parsedResponse");

        _attachments = await compute(
          (final data) => (data as List)
              .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList(),
          parsedResponse,
        );
        List<String> fileNames = _attachments.map((e) => e.fileName).toList();
        await fetchAttachedFiles(ticketId, fileNames, commentCall);
        AppLogger.info("Attachment Provider", "Attachments Fetching parsed: ${attachments[0].fileName}");
      } else {
        _error = 'Failed to load Attachments data';
        AppLogger.error(
            "Attachments Error: ", "$_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error(
          "Attachment Provider", "Attachments Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  String retrieveAttachedFileUrl(
      String ticketId, String commentCall, String fileName) {
    var url = ShareApiConfig.complaintAttachmentValue(ticketId: ticketId, fileName: fileName);
    switch (commentCall) {
      case "It":
        url = ShareApiConfig.complaintAttachmentValue(ticketId: ticketId, fileName: fileName);
        break;
      case "Alsanidi":
        url = ShareApiConfig.ecommerceAttachmentValue(ticketId: ticketId, fileName: fileName);
        break;
      case "Dynamics":
        url = MyShareApiConfig.dynamicAttachmentValue(ticketId: ticketId, fileName: fileName);
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
          ? await mySharePointDioClient.get(
              url,
              options: Options(
                responseType: ResponseType.bytes,
              ),
            )
          : await sharePointDioClient.get(
              url,
              options: Options(
                responseType: ResponseType.bytes,
              ),
            );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      }
    } catch (e) {
      AppLogger.error("Ecommerce Provider", "Download Exception: ${e.toString()}");
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
          _fetchedFileBytes.add(AttachedBytes(fileName: fileName, fileBytes: fileBytes, fileBytesBase64: null, fileType: null));
        }
      }
      if (_fetchedFileBytes.isEmpty) {
        _error = "No files fetched";
      }
    } catch (e) {
      AppLogger.error("Ecommerce Provider", "Ecommerce Image Exception: ${e.toString()}");
    }

    _loading = false;
    notifyListeners();
  }
}


