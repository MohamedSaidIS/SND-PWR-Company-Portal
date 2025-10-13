class VacationTransaction {
  final String hrTransId;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime profileDate;
  final double durationDays;
  final String absenceCode;
  final String personalNumber;

  VacationTransaction({
    required this.hrTransId,
    required this.startDate,
    required this.endDate,
    required this.profileDate,
    required this.durationDays,
    required this.absenceCode,
    required this.personalNumber,
  });

  factory VacationTransaction.fromJson(Map<String, dynamic> json) {
    return VacationTransaction(
      hrTransId: json['HRTransId'],
      startDate: DateTime.parse(json['StartDateTime']),
      endDate: DateTime.parse(json['EndDateTime']),
      profileDate: DateTime.parse(json['ProfileDate']),
      durationDays: json['DurationDays'].toDouble(),
      absenceCode: json['AbsenceCode'],
      personalNumber: json['PersonnelNumber'],
    );
  }
}
