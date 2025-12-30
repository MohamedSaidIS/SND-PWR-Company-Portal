import 'package:company_portal/data/constants.dart';
import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

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
        _creationResponse != null
            ? AppLogger.info("VacationPermissionRequest Provider",
                "VacationPermissionRequest Data Fetching ${_creationResponse!.success} ${_creationResponse!.message}")
            : AppLogger.info(
                "VacationPermissionRequest Provider", "${response.statusCode}");
        return true;
      } else {
        _error = 'Failed to load Personnel data';
        AppLogger.error("VacationPermissionRequest Provider",
            "VacationPermissionRequest Data Error: $_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error("VacationPermissionRequest Provider",
          "VacationPermissionRequest Data Exception: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> getPreviousRequests(String personnelNumber) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await kpiDioClient.getRequest(
        "https://alsenidiuat.sandbox.operations.dynamics.com/data/EmployeeRequests?\$filter=PersonnelNumber eq 'EMC000001' and StartDate ge ${Constants.currentStartDate.toIso8601String()} and EndDate  le ${Constants.currentEndDate.toIso8601String()}",
        true,
      );
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _previousRequests = await compute(
          (final data) {
            final List<PreviousRequests> list = (data['value'] as List)
                .map(
                    (e) => PreviousRequests.fromJson(e as Map<String, dynamic>))
                .toList();

            // ---------- 2) تجميع حسب TransId ----------
            final Map<String, PreviousRequests> grouped = {};

            for (var item in list) {
              final key = item.transId;

              if (!grouped.containsKey(key)) {
                grouped[key] = PreviousRequests(
                  personalNumber: item.personalNumber,
                  startDateTime: item.startDateTime,
                  endDateTime: item.endDateTime,
                  absenceCode: item.absenceCode,
                  approved: item.approved,
                  profileDate: item.profileDate,
                  transId: item.transId,
                  fileName: item.fileName,
                  fileType: item.fileType,
                  fileExtension: item.fileExtension,
                  attachments: [],
                );
              }

              if (item.attachment != null && item.attachment!.isNotEmpty) {
                grouped[key]!.attachments.add(AttachedBytes(
                    fileName: item.fileName,
                    fileType: item.fileType,
                    fileBytes: null,
                    fileBytesBase64: item.attachment!));
              }
            }
            final groupedList = grouped.values.toList();

            // ---------- 3) حساب التواريخ ----------
            final now = DateTime.now();

            final startPrevMonth = (now.month == 1)
                ? DateTime(now.year - 1, 12, 1)
                : DateTime(now.year, now.month - 1, 1);

            final endThisMonth = (now.month == 12)
                ? DateTime(now.year + 1, 1, 1)
                : DateTime(now.year, now.month + 1, 1);

            // ---------- 4) الفلترة بعد التجميع ----------
            final filtered = groupedList.where((req) {
              final date = req.startDateTime;
              if (date == null) return false;

              return date.isAfter(
                      startPrevMonth.subtract(const Duration(seconds: 1))) &&
                  date.isBefore(endThisMonth);
            }).toList();
            return filtered;
          },
          parsedResponse,
        );

        if (_previousRequests.isNotEmpty) {
          for (var i in _previousRequests) {
            AppLogger.info("VacationPermissionRequest Provider",
                "PreviousRequests Data ${response.statusCode} ${_previousRequests.length} ${i.absenceCode} ${i.approved} ${i.startDateTime} ${i.attachments.length} ${i.fileName} ${i.attachment}");
          }
        }
      } else {
        _error = 'Failed to load Personnel data';
        AppLogger.error("VacationPermissionRequest Provider",
            "VacationPermissionRequest Data Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error("VacationPermissionRequest Provider",
          "VacationPermissionRequest Data Exception: $_error");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
