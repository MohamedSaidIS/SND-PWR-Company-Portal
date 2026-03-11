class EnsureUser {
  final int id;
  final String email;

  EnsureUser({
    required this.id,
    required this.email,
  });

  factory EnsureUser.fromJson(Map<String, dynamic> json) {
    return EnsureUser(
      id: json['Id'],
      email: json['Email'],
    );
  }
}