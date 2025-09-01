import 'package:flutter/foundation.dart';

import '../models/sales_kpi.dart';
import '../service/kpi_dio_client.dart';
import '../utils/app_notifier.dart';

class KPIProvider extends ChangeNotifier{
  final KPIDioClient kpiDioClient;

  KPIProvider({required this.kpiDioClient});

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
            ? 'https://alsenidiuat.sandbox.operations.dynamics.com/data/WorkerSalesCommission?\$filter Worker eq $workerId'
            : 'https://alsanidi.operations.dynamics.com/data/WorkerSalesCommission?\$filter Worker eq $workerId',
      );

      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _kpiList = (parsedResponse['value'] as List)
            .map((e) => SalesKPI.fromJson(e as Map<String, dynamic>))
            // .where((cs) => cs.createdBy?.user?.id == userId)
            .toList();

        // _kpiList.sort((a, b) => b.createdDateTime!.compareTo(a.createdDateTime!));

        AppNotifier.printFunction("Sales KPI Fetching: ",
            "${response.statusCode} ${_kpiList[0].worker} ");
      } else {
        _error = 'Failed to load Sales KPI data';
        AppNotifier.printFunction(
            "Sales KPI Error: ", "$_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.printFunction("Sales KPI Exception: ", _error);
    }
    _loading = false;
    notifyListeners();

  }



}
