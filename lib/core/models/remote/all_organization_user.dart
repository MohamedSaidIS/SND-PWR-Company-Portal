class AllOrganizationUsers {
  final String? id;
  final String? displayName;
  final String? jobTitle;
  final String? mail;

  AllOrganizationUsers({
    required this.id,
    required this.displayName,
    required this.jobTitle,
    required this.mail,
  });

  factory AllOrganizationUsers.fromJson(Map<String, dynamic> json) {
    return AllOrganizationUsers(
        id: json['id'],
        displayName: json['displayName'],
        jobTitle: json['jobTitle'],
        mail: json['mail'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'display': displayName,
      'mail': mail,
    };
  }
}
