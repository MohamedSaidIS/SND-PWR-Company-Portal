import 'package:company_portal/models/local/attached_file_info.dart';

class PreviousRequests {
  final String personalNumber;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final String absenceCode;
  final String approved;
  final DateTime? profileDate;
  final String transId;
  final String fileType;
  final String fileExtension;
  final String fileName;
  String? attachment;
  List<AttachedBytes> attachments;

  PreviousRequests({
    required this.personalNumber,
    required this.startDateTime,
    required this.endDateTime,
    required this.absenceCode,
    required this.approved,
    required this.profileDate,
    required this.transId,
    required this.fileType,
    required this.fileExtension,
    required this.fileName,
    this.attachment,
    List<AttachedBytes>? attachments,
  }): attachments = attachments ?? [];

  factory PreviousRequests.fromJson(Map<String, dynamic> json) {
    return PreviousRequests(
      personalNumber: json['PersonnelNumber'],
      startDateTime: DateTime.parse(json['StartDateTime']),
      endDateTime: DateTime.parse(json['EndDateTime']),
      absenceCode: json['AbsenceCode'],
      approved: json['Approved'],
      profileDate: DateTime.parse(json['ProfileDate']),
      transId: json['TransId'],
      fileType: json['FileType'],
      fileName: json['FileName'],
      fileExtension: json['FileExtension'],
      attachment: json['Attachment'],
    );
  }
}
