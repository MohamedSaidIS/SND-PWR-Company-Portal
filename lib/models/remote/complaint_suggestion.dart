import 'package:company_portal/models/remote/complaint_suggestion_created_by.dart';
import 'package:company_portal/models/remote/complaint_suggestion_fields.dart';
import 'package:company_portal/models/remote/complaint_suggestion_last_modified_by.dart';

class ComplaintSuggestion {
  final String? id;
  final String? createdDateTime;
  final String? lastModifiedDateTime;
  final ComplaintSuggestionCreatedBy? createdBy;
  final ComplaintSuggestionLastModifiedBy? lastModifiedBy;
  final ComplaintSuggestionFields? fields;

  ComplaintSuggestion({
    required this.id,
    required this.createdDateTime,
    required this.lastModifiedDateTime,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.fields,
  });

  factory ComplaintSuggestion.fromJson(Map<String, dynamic> json) {
    return ComplaintSuggestion(
      id: json['id'],
      createdDateTime: json['createdDateTime'],
      lastModifiedDateTime: json['lastModifiedDateTime'],
      createdBy: json['createdBy'] != null
          ? ComplaintSuggestionCreatedBy.fromJson(json['createdBy'])
          : null,
      lastModifiedBy: json['lastModifiedBy'] != null
          ? ComplaintSuggestionLastModifiedBy.fromJson(json['lastModifiedBy'])
          : null,
      fields: json['fields'] != null
          ? ComplaintSuggestionFields.fromJson(json['fields'])
          : null,
    );
  }
}
