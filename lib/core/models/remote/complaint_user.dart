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