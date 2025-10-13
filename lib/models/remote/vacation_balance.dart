class VacationBalance {
  final String hrAbsenceCode;
  final double totalBalance;
  final double totalRemainingToDate;
  final int newBalance;
  final String workerName;
  final String personalNumber;

  VacationBalance({
    required this.hrAbsenceCode,
    required this.totalBalance,
    required this.totalRemainingToDate,
    required this.newBalance,
    required this.workerName,
    required this.personalNumber,
  });

  factory VacationBalance.fromJson(Map<String, dynamic> json) {
    return VacationBalance(
      hrAbsenceCode: json['HRMAbsenceCode'],
      totalBalance: json['TotalBalance'].toDouble(),
      totalRemainingToDate: json['TotalRemainingToDate'].toDouble(),
      newBalance: json['NewBalance'],
      workerName: json['WorkerName'],
      personalNumber: json['PersonnelNumber'],
    );
  }
}
