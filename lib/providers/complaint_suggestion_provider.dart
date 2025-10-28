import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class ComplaintSuggestionProvider with ChangeNotifier {
  final GraphDioClient dioClient;
  final SharePointDioClient sharePointDioClient;

  ComplaintSuggestionProvider(
      {required this.dioClient, required this.sharePointDioClient});



  List<ComplaintSuggestionItem> _complaintSuggestionList = [];
  bool _loading = false;
  String? _error;

  List<ComplaintSuggestionItem>? get complaintSuggestionList =>
      _complaintSuggestionList;


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

        _complaintSuggestionList = await compute(
          (Map<String, dynamic> input) {
            final data = input['data'] as Map<String, dynamic>;
            final userId = input['userId'] as String?;

            final list = (data['value'] as List)
                .map((e) =>
                    ComplaintSuggestionItem.fromJson(e as Map<String, dynamic>))
                .where((cs) => cs.createdBy?.user?.id == userId)
                .toList();

            list.sort(
                (a, b) => b.createdDateTime!.compareTo(a.createdDateTime!));
            return list;
          },
          {
            'data': parsedResponse,
            'userId': userId,
          },
        );

        AppNotifier.logWithScreen("ComplaintSuggestion Provider",
            "ComplaintSuggestion Fetching: ${response.statusCode} ${_complaintSuggestionList[0].fields?.priority} ");
      } else {
        _error = 'Failed to load ComplaintSuggestion data';
        AppNotifier.logWithScreen("ComplaintSuggestion Provider",
            "ComplaintSuggestion Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen("ComplaintSuggestion Provider",
          "ComplaintSuggestion Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createSuggestionsAndComplaints(String title, String description,
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
        },
      );

      if (response.statusCode == 201) {
        AppNotifier.logWithScreen("ComplaintSuggestion Provider",
            "ComplaintSuggestion Send: Success ${response.statusCode}");
        return true;
      } else {
        _error = 'Failed to send ComplaintSuggestion data';
        AppNotifier.logWithScreen("ComplaintSuggestion Provider",
            "ComplaintSuggestion Send Error:$_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen("ComplaintSuggestion Provider",
          "ComplaintSuggestion Send Exception: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

}
