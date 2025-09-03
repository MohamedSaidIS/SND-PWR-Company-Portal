import 'package:company_portal/models/remote/complaint_suggestion.dart';
import 'package:company_portal/service/dio_client.dart';
import 'package:flutter/foundation.dart';
import '../utils/app_notifier.dart';

class ComplaintSuggestionProvider with ChangeNotifier {
  final DioClient dioClient;

  ComplaintSuggestionProvider({required this.dioClient});

  List<ComplaintSuggestion> _complaintSuggestionList = [];
  bool _loading = false;
  String? _error;

  List<ComplaintSuggestion>? get complaintSuggestionList =>
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
        _complaintSuggestionList = (parsedResponse['value'] as List)
            .map((e) => ComplaintSuggestion.fromJson(e as Map<String, dynamic>))
            .where((cs) => cs.createdBy?.user?.id == userId)
            .toList();

        _complaintSuggestionList.sort((a, b) => b.createdDateTime!.compareTo(a.createdDateTime!));

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

Future<bool> sendSuggestionsAndComplaints(String title, String description, String priority, String department, String name) async {
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
        }
      }
    );

    if (response.statusCode == 201) {
      AppNotifier.printFunction("ComplaintSuggestion Send: ", "Success ${response.statusCode}");
      return true;
    } else {
      _error = 'Failed to send ComplaintSuggestion data';
      AppNotifier.printFunction(
          "ComplaintSuggestion Send Error: ", "$_error ${response.statusCode}");
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
}
