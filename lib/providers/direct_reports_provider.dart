import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class DirectReportsProvider with ChangeNotifier {
  final GraphDioClient dioClient;

  DirectReportsProvider({required this.dioClient});

  List<DirectReport>? _directReportList;
  bool _loading = false;
  String? _error;

  List<DirectReport>? get directReportList => _directReportList;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchRedirectReport() async {
    _loading = true;
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

        AppLogger.info("DirectReport Provider",
            "DirectReport Fetching: ${response.statusCode} $_directReportList ");
      } else {
        _error = 'Failed to load direct_report data';

        AppLogger.error("DirectReport Provider",
            "DirectReport Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error(
          "DirectReport Provider", "DirectReport Exception: $_error");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
