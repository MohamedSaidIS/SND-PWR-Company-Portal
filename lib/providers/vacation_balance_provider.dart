import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class VacationBalanceProvider extends ChangeNotifier {
  final KPIDioClient kpiDioClient;

  VacationBalanceProvider({required this.kpiDioClient});

  List<VacationTransaction> _vacationTransactions = [];
  VacationBalance? _vacationBalance;
  WorkerPersonnel? _workerPersonnel;
  bool _loading = false;
  String? _error;

  List<VacationTransaction> get vacationTransactions => _vacationTransactions;

  VacationBalance? get vacationBalance => _vacationBalance;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> getWorkerPersonnelNumber(String workerId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await kpiDioClient.getRequest(
          "https://alsenidiuat.sandbox.operations.dynamics.com/data/WorkerList?\$filter=Worker eq $workerId",
          true);
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _workerPersonnel = await compute(
          (final data) => (data['value'] as List)
              .map((e) => WorkerPersonnel.fromJson(e as Map<String, dynamic>))
              .first,
          parsedResponse,
        );
        if(_workerPersonnel != null){
          AppNotifier.logWithScreen("Vacation Balance Provider",
              "Personnel Data Fetching ${_workerPersonnel!.personnelNumber}");
          await getVacationBalance(_workerPersonnel!.personnelNumber);
        }

      } else {
        _error = 'Failed to load Personnel data';
        AppNotifier.logWithScreen("Vacation Balance Provider",
            "Personnel Data Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Vacation Balance Provider", "Personnel Data Exception: $_error");
    }
  }

  Future<void> getVacationTransactions(String workerId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await kpiDioClient.getRequest(
          "https://alsenidiuat.sandbox.operations.dynamics.com/data/AbsenceLines?\$filter=Worker eq $workerId and ProfileDate ge 2025-01-01T12:00:00Z and ProfileDate le 2025-12-31T12:00:00Z&\$count=true",
          true
      );
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _vacationTransactions = await compute(
          (final data) => (data['value'] as List)
              .map((e) =>
                  VacationTransaction.fromJson(e as Map<String, dynamic>))
              .toList(),
          parsedResponse,
        );

      } else {
        _error = 'Failed to load Vacation Transactions data';
        AppNotifier.logWithScreen("Vacation Balance Provider",
            "Vacation Transactions Error: $_error ${response.statusCode}");
      }

      _vacationTransactions.isNotEmpty
          ? AppNotifier.logWithScreen("Vacation Balance Provider",
              "Vacation Transactions Fetching: ${response.statusCode} ${_vacationTransactions[0].absenceCode}")
          : AppNotifier.logWithScreen("Vacation Balance Provider",
              "Vacation Transactions Fetching: ${response.statusCode}");
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen("Vacation Balance Provider",
          "Vacation Transactions Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> getVacationBalance(String personalNumber) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await kpiDioClient.getRequest(
          "https://alsenidiuat.sandbox.operations.dynamics.com/data/MyTeamLeaveBalances?\$filter= Year eq 2025 and PersonnelNumber eq '$personalNumber' &\$count=true",
          true
      );
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _vacationBalance = await compute(
              (final data) => (data['value'] as List)
              .map((e) => VacationBalance.fromJson(e as Map<String, dynamic>))
              .first,
          parsedResponse,
        );
      } else {
        _error = 'Failed to load Vacation Balance data';
        AppNotifier.logWithScreen("Vacation Balance Provider",
            "Vacation Balance Error: $_error ${response.statusCode}");
      }

      _vacationTransactions.isNotEmpty
          ? AppNotifier.logWithScreen("Vacation Balance Provider",
              "Vacation Balance Fetching: ${response.statusCode} ${_vacationBalance!.totalRemainingToDate}")
          : AppNotifier.logWithScreen("Vacation Balance Provider",
              "Vacation Balance Fetching: ${response.statusCode}");
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Vacation Balance Provider", "Vacation Balance Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }
}
