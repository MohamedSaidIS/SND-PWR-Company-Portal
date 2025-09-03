import 'package:company_portal/models/remote/direct_report.dart';
import 'package:company_portal/service/dio_client.dart';
import 'package:flutter/foundation.dart';
import '../utils/app_notifier.dart';

class DirectReportsProvider with ChangeNotifier {
  final DioClient dioClient;

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
        _directReportList = (parsedResponse['value'] as List)
            .map((redirectJson) => DirectReport.fromJson(redirectJson))
            .toList();

        AppNotifier.printFunction("DirectReport Fetching: ",
            "${response.statusCode} $_directReportList ");
      } else {
        _error = 'Failed to load direct_report data';
        AppNotifier.printFunction(
            "DirectReport Error: ", "$_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.printFunction("DirectReport Exception: ", _error);
    }
    _loading = false;
    notifyListeners();
  }
}
