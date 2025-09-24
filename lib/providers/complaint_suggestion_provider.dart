import 'package:company_portal/models/remote/complaint_suggestion.dart';
import 'package:company_portal/models/remote/item_comments.dart';
import 'package:company_portal/service/dio_client.dart';
import 'package:flutter/foundation.dart';
import '../service/shared_point_dio_client.dart';
import '../utils/app_notifier.dart';

class ComplaintSuggestionProvider with ChangeNotifier {
  final DioClient dioClient;
  final SharePointDioClient sharePointDioClient;

  ComplaintSuggestionProvider(
      {required this.dioClient, required this.sharePointDioClient});

  static String LIST_ID = '35274cd8-ad05-4d42-adc1-20a127aad3d3';

  List<ComplaintSuggestion> _complaintSuggestionList = [];
  List<ItemComments> _comments = [];
  bool _loading = false;
  String? _error;

  List<ComplaintSuggestion>? get complaintSuggestionList =>
      _complaintSuggestionList;

  List<ItemComments> get comments => _comments;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> fetchSuggestionsAndComplaints(String userId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.get(
          '/sites/a871adfa-9f2f-4347-8e57-dcc2e63d86b0/lists/35274cd8-ad05-4d42-adc1-20a127aad3d3/items?\$expand=fields');

      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _complaintSuggestionList = (parsedResponse['value'] as List)
            .map((e) => ComplaintSuggestion.fromJson(e as Map<String, dynamic>))
            .where((cs) => cs.createdBy?.user?.id == userId)
            .toList();

        _complaintSuggestionList
            .sort((a, b) => b.createdDateTime!.compareTo(a.createdDateTime!));

        AppNotifier.printFunction("ComplaintSuggestion Fetching: ",
            "${response.statusCode} ${_complaintSuggestionList[0].fields?.priority} ");
      } else {
        _error = 'Failed to load ComplaintSuggestion data';
        AppNotifier.printFunction(
            "ComplaintSuggestion Error: ", "$_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.printFunction("ComplaintSuggestion Exception: ", _error);
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> sendSuggestionsAndComplaints(String title, String description,
      String priority, String department, String name, int ensureUserId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.dio.post(
          '/sites/a871adfa-9f2f-4347-8e57-dcc2e63d86b0/lists/35274cd8-ad05-4d42-adc1-20a127aad3d3/items',
          data: {
            "fields": {
              "Title": title,
              "Description": description,
              "Priority": priority,
              "Department1": department,
              "Issue_x0020_logged_x0020_by1": name,
              "Status": "New",
              "IssueloggedbyLookupId": "$ensureUserId",
            }
          });

      if (response.statusCode == 201) {
        AppNotifier.printFunction(
            "ComplaintSuggestion Send: ", "Success ${response.statusCode}");
        return true;
      } else {
        _error = 'Failed to send ComplaintSuggestion data';
        AppNotifier.printFunction("ComplaintSuggestion Send Error: ",
            "$_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.printFunction("ComplaintSuggestion Send Exception: ", _error);
    }
    _loading = false;
    notifyListeners();
    return true;
  }

  Future<void> getComments(String ticketId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.dio.get(
          "https://alsanidi.sharepoint.com/sites/IT-Requests/_api/web/lists(guid'$LIST_ID')/items($ticketId)/comments");
      if (response.statusCode == 200) {
        final parsedResponse = response.data["value"];
        AppNotifier.printFunction(
            "ComplaintComments Fetching: ", parsedResponse);

        _comments = (parsedResponse as List)
            .map((e) => ItemComments.fromJson(e as Map<String, dynamic>))
            .toList();
        AppNotifier.printFunction(
            "ComplaintComments Fetching parsed: ", parsedResponse);
      } else {
        _error = 'Failed to load ComplaintComments data';
        AppNotifier.printFunction(
            "ComplaintComments Error: ", "$_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.printFunction("ComplaintComments Exception: ", _error);
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> postComments(String ticketId, String comment) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.dio.post(
          "https://alsanidi.sharepoint.com/sites/IT-Requests/_api/web/lists(guid'$LIST_ID')/items($ticketId)/comments",
          data: {
            "text" : comment,
          },
      );

      if(response.statusCode == 201){
        AppNotifier.printFunction("CommentSend: ", "Success ${response.statusCode}");
        await getComments(ticketId);

        return true;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.printFunction("CommentSend Exception: ", _error);
      return false;
    }
    _loading = false;
    notifyListeners();
    return true;
  }
}
