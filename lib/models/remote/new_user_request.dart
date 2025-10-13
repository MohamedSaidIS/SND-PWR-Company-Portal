class NewUserRequest {
  final int id;
  final String? title;
  final DateTime joiningDate;
  final String? location;
  final String? enName;
  final String? arName;
  final String? jobTitle;
  final String? phoneNo;
  final String? department;
  final String? deviceRequestType;
  final String? laptopNeeds;
  final String? specialSpecs;
  final String? specificSoftware;
  final String? newEmailRequest;
  final String? currentEmailToUse;
  final String? specifyNeedForNewEmail;
  final String? requestPhoneLine;
  final String? requestDynamicsAccount;
  final String? specifyDynamicsRole;

  NewUserRequest({
    required this.id,
    required this.title,
    required this.joiningDate,
    required this.location,
    required this.enName,
    required this.arName,
    required this.jobTitle,
    required this.phoneNo,
    required this.department,
    required this.deviceRequestType,
    required this.laptopNeeds,
    required this.specialSpecs,
    required this.specificSoftware,
    required this.newEmailRequest,
    required this.currentEmailToUse,
    required this.specifyNeedForNewEmail,
    required this.requestPhoneLine,
    required this.requestDynamicsAccount,
    required this.specifyDynamicsRole,
  });

  factory NewUserRequest.fromJson(Map<String, dynamic> json){
    return NewUserRequest(
        id: json['Id'],
        title: json['Title'],
        joiningDate: DateTime.parse(json['field_1']),
        location: json['field_2'],
        enName: json['field_3'],
        arName: json['field_4'],
        jobTitle: json['Title_x0020__x002d__x0020__x0627'],
        phoneNo: json['field_5'],
        department: json['field_6'],
        deviceRequestType: json['field_8'],
        laptopNeeds: json['field_9'],
        specialSpecs: json['field_10'],
        specificSoftware: json['field_11'],
        newEmailRequest: json['field_12'],
        currentEmailToUse: json['Current_x0020_Email_x0020_to_x00'],
        specifyNeedForNewEmail: json['field_14'],
        requestPhoneLine: json['field_15'],
        requestDynamicsAccount: json['field_16'],
        specifyDynamicsRole: json['field_17']
    );
  }
}
