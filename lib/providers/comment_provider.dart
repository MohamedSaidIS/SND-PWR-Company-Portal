import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class CommentProvider extends ChangeNotifier {
  final SharePointDioClient sharePointDioClient;
  final MySharePointDioClient mySharePointDioClient;

  CommentProvider(
      {required this.sharePointDioClient, required this.mySharePointDioClient});

  static const itListId = '35274cd8-ad05-4d42-adc1-20a127aad3d3';
  static const alsanidiListId = 'c09e3694-3b81-43b5-b39c-49a26155612e';
  static const dynamicsListId = '3b2e2dd6-55a0-4ee4-b517-5ccd63b6a12a';

  List<ItemComments> _comments = [];
  bool _loading = false;
  String? _error;

  List<ItemComments> get comments => _comments;

  bool get loading => _loading;

  String? get error => _error;

  String retrieveUrl(String ticketId, String commentCall) {
    var url =
        "/sites/IT-Requests/_api/web/lists(guid'$itListId')/items($ticketId)/comments";
    switch (commentCall) {
      case "It":
        url =
            "/sites/IT-Requests/_api/web/lists(guid'$itListId')/items($ticketId)/comments";
        break;
      case "Alsanidi":
        url =
            "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'$alsanidiListId')/items($ticketId)/comments";
        break;
      case "Dynamics":
        url =
            "/_api/Web/Lists(guid'$dynamicsListId')/items($ticketId)/comments";
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
          ? await mySharePointDioClient.dio.get(url)
          : await sharePointDioClient.dio.get(url);

      if (response.statusCode == 200) {
        final parsedResponse = response.data["value"];
        AppNotifier.logWithScreen(
            "Comment Provider", "Comments Fetching: $parsedResponse");

        _comments = await compute(
          (final data) => (data as List)
              .map((e) => ItemComments.fromJson(e as Map<String, dynamic>))
              .toList(),
          parsedResponse,
        );

        AppNotifier.logWithScreen(
            "Comment Provider", "Comments Fetching parsed: $parsedResponse");
      } else {
        _error = 'Failed to load Comments data';
        AppNotifier.logWithScreen(
            "Comments Error: ", "$_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
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
    debugPrint("post Url $url");

    try {
      final response = (commentCall == " Dynamics")
          ? await mySharePointDioClient.dio.post(
              url,
              data: {
                "text": comment,
                "mentions": mentions,
              },
            )
          : await sharePointDioClient.dio.post(
              url,
              data: {
                "text": comment,
                "mentions": mentions,
              },
            );

      if (response.statusCode == 201) {
        AppNotifier.logWithScreen(
            "Comment Provider", "CommentSend: Success ${response.statusCode}");

        Future.microtask(() => getComments(ticketId, commentCall));

        return true;
      } else {
        _error = 'Failed to send comment. Status code: ${response.statusCode}';
        AppNotifier.logWithScreen("Comments Error: ", "$_error");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
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
      final response = await mySharePointDioClient.dio.get(url);

      if (response.statusCode == 200) {
        final parsedResponse = response.data["value"];
        AppNotifier.logWithScreen(
            "Comment Provider", "Dynamics Comments Fetching: $parsedResponse");

        _comments = await compute(
              (final data) => (data as List)
              .map((e) => ItemComments.fromJson(e as Map<String, dynamic>))
              .toList(),
          parsedResponse,
        );

        AppNotifier.logWithScreen(
            "Comment Provider", "Dynamics Comments Fetching parsed: $parsedResponse");
      } else {
        _error = 'Failed to load Comments data';
        AppNotifier.logWithScreen(
            "Comments Error: ", "$_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
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
      final response = await mySharePointDioClient.dio.post(
        url,
        data: {
          "text": comment,
          "mentions": mentions,
        },
      );

      if (response.statusCode == 201) {
        AppNotifier.logWithScreen(
            "Comment Provider", "Dynamics CommentSend: Success ${response.statusCode}");

        Future.microtask(() => getDynamicsComments(ticketId, commentCall));

        return true;
      } else {
        _error = 'Failed to send comment. Status code: ${response.statusCode}';
        AppNotifier.logWithScreen("Dynamics Comments Error: ", "$_error");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Comment Provider", " Dynamics CommentSend Exception: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
