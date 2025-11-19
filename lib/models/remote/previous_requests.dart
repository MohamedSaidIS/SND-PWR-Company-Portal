class PreviousRequests {
  final String personalNumber;

  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final String absenceCode;
  final String approved;

  PreviousRequests({
    required this.personalNumber,
    required this.startDateTime,
    required this.endDateTime,
    required this.absenceCode,
    required this.approved,
  });

  factory PreviousRequests.fromJson(Map<String, dynamic> json) {
    return PreviousRequests(
      personalNumber: json['PersonnelNumber'],
      startDateTime: DateTime.parse(json['StartDateTime']),
      endDateTime: DateTime.parse(json['EndDateTime']),
      absenceCode: json['AbsenceCode'],
      approved: json['Approved'],
    );
  }
}
