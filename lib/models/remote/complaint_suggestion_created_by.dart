import 'complaint_user.dart';

class ComplaintSuggestionCreatedBy {
  final User? user;

  ComplaintSuggestionCreatedBy({this.user});

  factory ComplaintSuggestionCreatedBy.fromJson(Map<String, dynamic> json) {
    return ComplaintSuggestionCreatedBy(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}


