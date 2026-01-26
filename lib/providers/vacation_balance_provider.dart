import 'package:flutter/foundation.dart';

import '../data/constants.dart';
import '../utils/export_import.dart';

class VacationBalanceProvider extends ChangeNotifier {
  final KPIDioClient kpiDioClient;

  VacationBalanceProvider({required this.kpiDioClient});

  List<VacationTransaction> _vacationTransactions = [];
  VacationBalance? _vacationBalance;
  WorkerPersonnel? _workerPersonnel;
  bool _loading = true;
  String? _error;

  List<VacationTransaction> get vacationTransactions => _vacationTransactions;

  VacationBalance? get vacationBalance => _vacationBalance;

  WorkerPersonnel? get personnelNumber => _workerPersonnel;

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
        if (_workerPersonnel != null) {
          AppLogger.info("Vacation Balance Provider",
              "Personnel Data Fetching ${_workerPersonnel!.personnelNumber}");
          await getVacationBalance(_workerPersonnel!.personnelNumber);
        }
      } else {
        _error = 'Failed to load Personnel data';
        AppLogger.error("Vacation Balance Provider",
            "Personnel Data Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error(
          " ", "Personnel Data Exception: $_error");
    }
  }

  Future<void> getVacationTransactions(String workerId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    print("Transactions Url: https://alsenidiuat.sandbox.operations.dynamics.com/data/AbsenceLines?\$filter=Worker eq $workerId and ProfileDate ge ${Constants.currentStartDate.toIso8601String()} and ProfileDate le ${Constants.currentEndDate.toIso8601String()}&\$count=true");

    try {
      final response = await kpiDioClient.getRequest(
          "https://alsenidiuat.sandbox.operations.dynamics.com/data/AbsenceLines?\$filter=Worker eq $workerId and ProfileDate ge ${Constants.currentStartDate.toIso8601String()} and ProfileDate le ${Constants.currentEndDate.toIso8601String()}&\$count=true",
          true);
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _vacationTransactions = await compute(
          (final data) => (data['value'] as List)
              .map((e) =>
                  VacationTransaction.fromJson(e as Map<String, dynamic>))
              .where((item) => item.absenceCode != "ح.غ.م تأخي")
              .toList(),
          parsedResponse,
        );
        _vacationTransactions.isNotEmpty
            ? AppLogger.info("Vacation Balance Provider",
            "Vacation Transactions Fetching: ${response.statusCode} ${_vacationTransactions[0].absenceCode}")
            : AppLogger.info("Vacation Balance Provider",
            "Vacation Transactions Fetching: ${response.statusCode}");
      } else {
        _error = 'Failed to load Vacation Transactions data';
        AppLogger.error("Vacation Balance Provider",
            "Vacation Transactions Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error("Vacation Balance Provider",
          "Vacation Transactions Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> getVacationBalance(String personalNumber) async {
    _loading = true;
    _error = null;
    notifyListeners();

    print("Url: https://alsenidiuat.sandbox.operations.dynamics.com/data/MyTeamLeaveBalances?\$filter= Year eq ${Constants.currentYear} and PersonnelNumber eq '$personalNumber' &\$count=true");
    try {
      final response = await kpiDioClient.getRequest(
          "https://alsenidiuat.sandbox.operations.dynamics.com/data/MyTeamLeaveBalances?\$filter= Year eq ${Constants.currentYear} and PersonnelNumber eq '$personalNumber' &\$count=true",
          true);
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _vacationBalance = await compute(
          (final data) {
            final list = data['value'] as List;
            if(list.isEmpty){
              AppLogger.info("Vacation Balance Provider", "Vacation Balance is: 0");
              return null;
            }
            AppLogger.info("Vacation Balance Provider", "Vacation Balance is: ${_vacationBalance!.remain}");
            return VacationBalance.fromJson(
              list.first as Map<String, dynamic>,
            );
          },
          parsedResponse,
        );
      } else {
        _error = 'Failed to load Vacation Balance data';
        AppLogger.error("Vacation Balance Provider",
            "Vacation Balance Error: $_error ${response.statusCode}");
      }

      _vacationTransactions.isNotEmpty
          ? AppLogger.info("Vacation Balance Provider",
              "Vacation Balance Fetching: ${response.statusCode} ${_vacationBalance!.remain}")
          : AppLogger.info("Vacation Balance Provider",
              "Vacation Balance Fetching: ${response.statusCode}");
    } catch (e) {
      _error = e.toString();
      AppLogger.error(
          "Vacation Balance Provider", "Vacation Balance Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }
}
