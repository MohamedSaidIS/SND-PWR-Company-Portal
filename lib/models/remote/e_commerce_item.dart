class EcommerceItem {
  final int id;
  final String? title;
  final String? description;
  final String? priority;
  final String? status;
  final int? assignedToId;
  final int? authorId;
  final DateTime createdDate;
  final DateTime modifiedDate;
  final int? issueLoggedById;
  final String? type;
  final List<String> app;

  EcommerceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.assignedToId,
    required this.authorId,
    required this.createdDate,
    required this.modifiedDate,
    required this.issueLoggedById,
    required this.type,
    required this.app,
  });

  factory EcommerceItem.fromJson(Map<String, dynamic> json) {
    return EcommerceItem(
      id: json['Id'],
      title: json['Title'],
      description: json['Description'],
      priority: json['Priority'],
      status: json['Status'],
      assignedToId: json['Assignedto0Id'],
      authorId: json['AuthorId'],
      createdDate: DateTime.parse(json['Created']),
      modifiedDate: DateTime.parse(json['Modified']),
      issueLoggedById: json['IssueloggedbyId'],
      type: json['Type'],
      app: (json['App'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    "Title": title,
    "Description": description,
    "Priority": priority,
    "Status": status,
    "Assignedto0Id": assignedToId,
    "Assignedto0StringId": assignedToId.toString(),
    "IssueloggedbyId": issueLoggedById,
    "IssueloggedbyStringId": issueLoggedById.toString(),
    "Type": type,
    "App": app,
    "Created": createdDate.toIso8601String(),
    "AuthorId": authorId,
  };
}
