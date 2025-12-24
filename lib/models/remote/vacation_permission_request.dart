import '../../utils/export_import.dart';

class VacationPermissionRequest {
  final DateTime profileDate = DateTime.now();
  final DateTime startDate;
  final DateTime endDate;
  final String personnelNumber;
  final String absenceCode;
  final String notes;
  final List<VacationAttachment>? attachments;

  VacationPermissionRequest({
    required this.startDate,
    required this.endDate,
    required this.personnelNumber,
    required this.absenceCode,
    required this.notes,
    required this.attachments,
  });

  Map<String, dynamic> toJson() => {
        "ProfileDate": formatToUtcIsoString(profileDate),
        "StartDateTime": formatToUtcIsoString(startDate),
        "EndDateTime": formatToUtcIsoString(endDate),
        "PersonnelNumber": personnelNumber,
        "AbsenceCode": absenceCode,
        "Notes": notes,
        "Lines": attachments
      };
}

String formatToUtcIsoString(DateTime date) {
  final utcDate = DateTime.utc(
    date.year,
    date.month,
    date.day,
    date.hour,
    date.minute,
    0, // second = 0
  );
  return '${utcDate.toIso8601String().split('.').first}Z';
}

//////////////////////////////////////////  Second Model \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

class VacationPermissionResponse {
  final bool success;
  final String message;

  VacationPermissionResponse({
    required this.success,
    required this.message,
  });

  factory VacationPermissionResponse.fromJson(Map<String, dynamic> json) {
    return VacationPermissionResponse(
      success: json['Success'],
      message: json['Message'],
    );
  }
}
