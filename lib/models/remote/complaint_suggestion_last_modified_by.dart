import 'complaint_user.dart';

class ComplaintSuggestionLastModifiedBy {
  final User? user;

  ComplaintSuggestionLastModifiedBy({this.user});

  factory ComplaintSuggestionLastModifiedBy.fromJson(Map<String, dynamic> json) {
    return ComplaintSuggestionLastModifiedBy(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}
