class ComplaintSuggestionCreatedBy {
  final User? user;

  ComplaintSuggestionCreatedBy({this.user});

  factory ComplaintSuggestionCreatedBy.fromJson(Map<String, dynamic> json) {
    return ComplaintSuggestionCreatedBy(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}


class User {
  final String? email;
  final String? id;
  final String? displayName;

  User({this.email, this.id, this.displayName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      id: json['id'],
      displayName: json['displayName'],
    );
  }
}