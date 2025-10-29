import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class SalesKPIProvider extends ChangeNotifier {
  final KPIDioClient kpiDioClient;

  SalesKPIProvider({required this.kpiDioClient});

  List<SalesKPI> _kpiList = [];
  bool _loading = false;
  String? _error;

  List<SalesKPI>? get kpiList => _kpiList;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> getSalesKpi(String workerId, {required bool isUAT}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await kpiDioClient.getRequest(
          isUAT
              ? "https://alsenidiuat.sandbox.operations.dynamics.com/data/WorkerSalesCommission/?\$filter= Worker  eq {$workerId}"
              : "https://alsanidi.operations.dynamics.com/data/WorkerSalesCommission/?\$filter= Worker  eq {$workerId}",
          isUAT);
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _kpiList = await compute(
          (final data) => (data['value'] as List)
              .map((e) => SalesKPI.fromJson(e as Map<String, dynamic>))
              .toList(),
          parsedResponse,
        );

        // _kpiList.sort((a, b) => b.createdDateTime!.compareTo(a.createdDateTime!));
        _kpiList.isNotEmpty
            ? AppNotifier.logWithScreen("Sales Kpi Provider",
                "Sales KPI Fetching: ${response.statusCode} ${_kpiList[0].worker}")
            : AppNotifier.logWithScreen("Sales Kpi Provider",
                "Sales KPI Fetching: ${response.statusCode}");
      } else {
        _error = 'Failed to load Sales KPI data';
        AppNotifier.logWithScreen("Sales Kpi Provider",
            "Sales KPI Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Sales Kpi Provider", "Sales KPI Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }
}
