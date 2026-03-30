import 'package:company_portal/core/data/remote_data/dio_share_point/share_api_config.dart';
import 'package:flutter/foundation.dart';
import '../../../utils/export_import.dart';
import '../core/data/remote_data/dio_my_share_point/my_share_api_config.dart';

class CommentProvider extends ChangeNotifier {
  final SharePointDioClient sharePointDioClient;
  final MySharePointDioClient mySharePointDioClient;

  CommentProvider(
      {required this.sharePointDioClient, required this.mySharePointDioClient});



  List<ItemComments> _comments = [];
  bool _loading = false;
  String? _error;

  List<ItemComments> get comments => _comments;

  bool get loading => _loading;

  String? get error => _error;

  String retrieveUrl(String ticketId, String commentCall) {
    var url = ShareApiConfig.complaintComments(ticketId: ticketId);

    switch (commentCall) {
      case "It":
        url = ShareApiConfig.complaintComments(ticketId: ticketId);
        break;
      case "Alsanidi":
        url = ShareApiConfig.ecommerceComments(ticketId: ticketId);
        break;
      case "Dynamics":
        url = MyShareApiConfig.dynamicsComments(ticketId: ticketId);
        break;
    }
    return url;
  }

  Future<void> getComments(String ticketId, String commentCall) async {
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
            "Comment Provider", "Comments Fetching: $parsedResponse");

        _comments = await compute(
          (final data) => (data as List)
              .map((e) => ItemComments.fromJson(e as Map<String, dynamic>))
              .toList(),
          parsedResponse,
        );

        AppLogger.info(
            "Comment Provider", "Comments Fetching parsed: $parsedResponse");
      } else {
        _error = 'Failed to load Comments data';
        AppLogger.error(
            "Comments Error: ", "$_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error(
          "Comment Provider", "Comments Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> sendComments(String ticketId, String comment, String commentCall, {required List<Map<String, dynamic>> mentions}
      ) async {
    _loading = true;
    _error = null;
    notifyListeners();
    final url = retrieveUrl(ticketId, commentCall);
    debugPrint("sendComments Url $url");

    try {
      final response = (commentCall == " Dynamics")
          ? await mySharePointDioClient.post(
              url,
              data: {
                "text": comment,
                "mentions": mentions,
              },
            )
          : await sharePointDioClient.post(
              url,
              data: {
                "text": comment,
                "mentions": mentions,
              },
            );

      if (response.statusCode == 201) {
        AppLogger.info(
            "Comment Provider", "CommentSend: Success ${response.statusCode}");

        Future.microtask(() => getComments(ticketId, commentCall));

        return true;
      } else {
        _error = 'Failed to send comment. Status code: ${response.statusCode}';
        AppLogger.error("Comments Error: ", "$_error");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error(
          "Comment Provider", "CommentSend Exception: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> getDynamicsComments(String ticketId, String commentCall) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final url = retrieveUrl(ticketId, commentCall);
    debugPrint("Dynamics Get Url $url");

    try {
      final response = await mySharePointDioClient.get(url);

      if (response.statusCode == 200) {
        final parsedResponse = response.data["value"];
        AppLogger.info(
            "Comment Provider", "Dynamics Comments Fetching: $parsedResponse");

        _comments = await compute(
              (final data) => (data as List)
              .map((e) => ItemComments.fromJson(e as Map<String, dynamic>))
              .toList(),
          parsedResponse,
        );

        AppLogger.info(
            "Comment Provider", "Dynamics Comments Fetching parsed: $parsedResponse");
      } else {
        _error = 'Failed to load Comments data';
        AppLogger.error(
            "Comments Error: ", "$_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error(
          "Comment Provider", " Dynamics Comments Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> sendDynamicsComments(String ticketId, String comment, String commentCall, {required List<Map<String, dynamic>> mentions}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    final url = retrieveUrl(ticketId, commentCall);
    debugPrint("Dynamics Post Url $url");

    try {
      final response = await mySharePointDioClient.post(
        url,
        data: {
          "text": comment,
          "mentions": mentions,
        },
      );

      if (response.statusCode == 201) {
        AppLogger.info(
            "Comment Provider", "Dynamics CommentSend: Success ${response.statusCode}");

        Future.microtask(() => getDynamicsComments(ticketId, commentCall));

        return true;
      } else {
        _error = 'Failed to send comment. Status code: ${response.statusCode}';
        AppLogger.error("Dynamics Comments Error: ", "$_error");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error(
          "Comment Provider", " Dynamics CommentSend Exception: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
