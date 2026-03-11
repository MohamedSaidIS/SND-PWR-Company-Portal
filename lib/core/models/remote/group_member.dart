class GroupMember{
  final String memberId;
  final String? displayName;
  final String? givenName;
  final String? surname;
  final String? mail;
  final String? jobTitle;

  GroupMember({
    required this.memberId,
    required this.displayName,
    required this.givenName,
    required this.surname,
    required this.mail,
    required this.jobTitle,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json){
    return GroupMember(
      memberId: json ['id'],
      displayName: json ['displayName'],
      givenName: json ['givenName'],
      surname: json ['surname'],
      mail: json ['mail'],
      jobTitle: json ['jobTitle'],
    );
  }

}