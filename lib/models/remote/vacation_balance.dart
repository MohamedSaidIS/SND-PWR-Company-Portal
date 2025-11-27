class VacationBalance {
  final String hrAbsenceCode;
  final double currentBalance;
  final double remain;
  final int consumedDays;
  final String workerName;
  final String personalNumber;

  VacationBalance({
    required this.hrAbsenceCode,
    required this.currentBalance,
    required this.remain,
    required this.consumedDays,
    required this.workerName,
    required this.personalNumber,
  });

  factory VacationBalance.fromJson(Map<String, dynamic> json) {
    return VacationBalance(
      hrAbsenceCode: json['HRMAbsenceCode'],
      currentBalance: json['TotalCurrentToDateNotRemainingNewVersion'].toDouble(),
      remain: json['TotalRemainingToDate'].toDouble(),
      consumedDays: json['ConsumedDays'],
      workerName: json['WorkerName'],
      personalNumber: json['PersonnelNumber'],
    );
  }
}
