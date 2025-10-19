import 'package:company_portal/models/remote/vacation_balance.dart';
import 'package:company_portal/models/remote/vacation_transaction.dart';
import 'package:company_portal/service/kpi_dio_client.dart';
import 'package:flutter/foundation.dart';

import '../utils/app_notifier.dart';

class VacationBalanceProvider extends ChangeNotifier {
  final KPIDioClient kpiDioClient;

  VacationBalanceProvider({required this.kpiDioClient});

  List<VacationTransaction> _vacationTransactions = [];
  VacationBalance? _vacationBalance;
  bool _loading = false;
  String? _error;

  List<VacationTransaction> get vacationTransactions => _vacationTransactions;
  VacationBalance? get vacationBalance => _vacationBalance;
  bool get loading => _loading;
  String? get error => _error;


  Future<void> getVacationTransactions(String workerId) async{
    _loading = true;
    _error = null;
    notifyListeners();

    try{
      final response = await kpiDioClient.getRequest(
      "https://alsanidi.operations.dynamics.com/data/AbsenceLines?\$filter=Worker eq $workerId and ProfileDate ge 2025-01-01T12:00:00Z and ProfileDate le 2025-12-31T12:00:00Z&\$count=true",
          false
      );
      if(response.statusCode == 200){
        final parsedResponse = response.data;
        _vacationTransactions = await compute(
            (final data) => (data['value'] as List)
                .map((e) => VacationTransaction.fromJson(e as Map<String, dynamic>))
                .toList(),
          parsedResponse,
        );

        await getVacationBalance(_vacationTransactions[0].personalNumber);

      }else {
        _error = 'Failed to load Vacation Transactions data';
        AppNotifier.logWithScreen(
            "Vacation Balance Provider", "Vacation Transactions Error: $_error ${response.statusCode}");
      }

      _vacationTransactions.isNotEmpty
          ? AppNotifier.logWithScreen("Vacation Balance Provider",
          "Vacation Transactions Fetching: ${response.statusCode} ${_vacationTransactions[0].absenceCode}")
          : AppNotifier.logWithScreen("Vacation Balance Provider",
          "Vacation Transactions Fetching: ${response.statusCode}");

    }catch(e){
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Vacation Balance Provider", "Vacation Transactions Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> getVacationBalance(String personalNumber)async{
    _loading = true;
    _error = null;
    notifyListeners();

    try{
      final response = await kpiDioClient.getRequest(
          "https://alsanidi.operations.dynamics.com/data/MyTeamLeaveBalances",
          false
      );
      if(response.statusCode == 200){
        final parsedResponse = response.data;
        _vacationBalance = await compute(
              (final data) => VacationBalance.fromJson(
            data['value'][0] as Map<String, dynamic>,
          ),
          parsedResponse,
        );

      }else {
        _error = 'Failed to load Vacation Balance data';
        AppNotifier.logWithScreen(
            "Vacation Balance Provider", "Vacation Balance Error: $_error ${response.statusCode}");
      }

      _vacationTransactions.isNotEmpty
          ? AppNotifier.logWithScreen("Vacation Balance Provider",
          "Vacation Balance Fetching: ${response.statusCode} ${_vacationBalance!.totalRemainingToDate}")
          : AppNotifier.logWithScreen("Vacation Balance Provider",
          "Vacation Balance Fetching: ${response.statusCode}");

    }catch(e){
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Vacation Balance Provider", "Vacation Balance Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

}
