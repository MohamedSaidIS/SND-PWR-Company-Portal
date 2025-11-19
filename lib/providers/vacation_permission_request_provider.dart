import 'package:company_portal/models/remote/previous_requests.dart';
import 'package:company_portal/models/remote/vacation_permission_request.dart';
import 'package:flutter/foundation.dart';

import '../service/kpi_dio_client.dart';
import '../utils/app_notifier.dart';

class VacationPermissionRequestProvider extends ChangeNotifier {
  final KPIDioClient kpiDioClient;

  VacationPermissionRequestProvider({required this.kpiDioClient});

  VacationPermissionResponse? _creationResponse;
  List<PreviousRequests> _previousRequests = [];
  bool _loading = false;
  String? _error;

  VacationPermissionResponse? get creationResponse => _creationResponse;

  List<PreviousRequests> get previousRequests => _previousRequests;

  bool get loading => _loading;

  String? get error => _error;

  Future<bool> createRequest(
      String selectedType, VacationPermissionRequest request) async {
    _loading = true;
    _error = null;
    notifyListeners();
    print("Vacation Request ${request.toJson()}");
    try {
      final response = await kpiDioClient.postRequest(
          selectedType == "Vacation"
              ? "https://alsenidiuat.sandbox.operations.dynamics.com/api/services/HRMSrvGroup/HRMSrv/CreateVacation"
              : "https://alsenidiuat.sandbox.operations.dynamics.com/api/services/HRMSrvGroup/HRMSrv/CreatePermission",
          true,
          data: {
            "_contract": request.toJson(),
          });
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _creationResponse = await compute(
          (final data) => VacationPermissionResponse.fromJson(data),
          parsedResponse,
        );
        if (_creationResponse != null) {
          AppNotifier.logWithScreen("VacationPermissionRequest Provider",
              "VacationPermissionRequest Data Fetching ${_creationResponse!.success} ${_creationResponse!.message}");
        }
        AppNotifier.logWithScreen(
            "VacationPermissionRequest Provider", "${response.statusCode}");
        return true;
      } else {
        _error = 'Failed to load Personnel data';
        AppNotifier.logWithScreen("VacationPermissionRequest Provider",
            "VacationPermissionRequest Data Error: $_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen("VacationPermissionRequest Provider",
          "VacationPermissionRequest Data Exception: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> getPreviousRequests(String workerId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    //ToDO: Use Prod url and worker Id
    try {
      final response = await kpiDioClient.getRequest(
        "https://alsenidiuat.sandbox.operations.dynamics.com/data/EmployeeRequests?\$filter=PersonnelNumber eq 'EMC000085'  and StartDate ge 2025-01-01T12:00:00Z and StartDate le 2025-12-31T12:00:00Z&\$count=true",
        true,
      );
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _previousRequests = await compute(
          (final data) => (data['value'] as List)
              .map((e) => PreviousRequests.fromJson(e as Map<String, dynamic>))
              .toList(),
          parsedResponse,
        );
        if (_previousRequests.isNotEmpty) {
          AppNotifier.logWithScreen("VacationPermissionRequest Provider",
              "PreviousRequests Data ${response.statusCode} ${_previousRequests[0].absenceCode} ${_previousRequests[0].approved}");
        }
      } else {
        _error = 'Failed to load Personnel data';
        AppNotifier.logWithScreen("VacationPermissionRequest Provider",
            "VacationPermissionRequest Data Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen("VacationPermissionRequest Provider",
          "VacationPermissionRequest Data Exception: $_error");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
