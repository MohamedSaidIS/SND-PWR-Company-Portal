class DynamicsItem {
  final int id;
  final String? title;
  final String? description;
  final String? priority;
  final String? status;
  final int? authorId;
  final DateTime? createdDate;
  final DateTime? modifiedDate;
  final DateTime? dateReported;
  final String area;
  final String purpose;

  DynamicsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.authorId,
    required this.createdDate,
    required this.modifiedDate,
    required this.dateReported,
    required this.area,
    required this.purpose,
  });

  factory DynamicsItem.fromJson(Map<String, dynamic> json) {
    return DynamicsItem(
      id: json['Id'],
      title: json['Title'],
      description: json['Description'],
      priority: json['Priority'],
      status: json['Status'],
      authorId: json['AuthorId'],
      createdDate: DateTime.parse(json['Created']),
      modifiedDate: DateTime.parse(json['Modified']),
      dateReported: DateTime.parse(json['DateReported']),
      area: json['Area'],
      purpose: json['Purpose'],
    );
  }

  Map<String, dynamic> toJson() => {
    "Title": title,
    "Description": description,
    "Priority": priority,
    "Status": status,
    "AuthorId": authorId,
    "DateReported": dateReported!.toIso8601String(),
    "Area": area,
    "Purpose": purpose,
  };

}
