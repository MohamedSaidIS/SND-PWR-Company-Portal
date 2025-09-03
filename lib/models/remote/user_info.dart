class UserInfo {
  final String id;
  final String? displayName;
  final String? givenName;
  final String? surname;
  final String? jobTitle;
  final String? mail;
  final String? mobilePhone;
  final String? officeLocation;
  final String? userPrincipalName;

  UserInfo({
    required this.id,
    required this.displayName,
    required this.givenName,
    required this.surname,
    required this.jobTitle,
    required this.mail,
    required this.mobilePhone,
    required this.officeLocation,
    required this.userPrincipalName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json){
    return UserInfo(
      id: json ['id'],
      displayName: json ['displayName'],
      givenName: json ['givenName'],
      surname: json ['surname'],
      jobTitle: json ['jobTitle'],
      mail: json ['mail'],
      mobilePhone: json ['mobilePhone'],
      officeLocation: json ['officeLocation'],
      userPrincipalName: json ['userPrincipalName'],
    );
  }

}
