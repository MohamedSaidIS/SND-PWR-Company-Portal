import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class DirectReportsProvider with ChangeNotifier {
  final GraphDioClient dioClient;

  DirectReportsProvider({required this.dioClient});

  List<DirectReport>? _directReportList;
  ViewState _state = ViewState.loading;
  String? _error;

  List<DirectReport>? get directReportList => _directReportList;
  ViewState get state => _state;
  String? get error => _error;

  Future<void> fetchRedirectReport() async {
    _state = ViewState.loading;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.get('/me/directReports');

      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _directReportList = await compute(
          (final data) => (data['value'] as List)
              .map((redirectJson) => DirectReport.fromJson(redirectJson))
              .toList(),
          parsedResponse,
        );

        AppNotifier.logWithScreen("DirectReport Provider",
            "DirectReport Fetching: ${response.statusCode} $_directReportList ");
        if (_directReportList == null || _directReportList!.isEmpty) {
          _state = ViewState.empty;
        } else {
          _state = ViewState.data;
        }
      } else {
        _error = 'Failed to load direct_report data';
        _state = ViewState.error;

        AppNotifier.logWithScreen("DirectReport Provider",
            "DirectReport Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      _state = ViewState.error;

      AppNotifier.logWithScreen(
          "DirectReport Provider", "DirectReport Exception: $_error");
    }
    notifyListeners();
  }
}
