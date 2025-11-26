class ComplaintSuggestionItem {
  final int? id;
  final String? title;
  final String? description;
  final String? priority;
  final String? status;
  final String? department;
  final DateTime? createdDate;
  final DateTime? modifiedDate;
  final int? assignedToId;
  final int? authorId;
  final int? issueLoggedById;
  final String? issueLoggedByName;

  ComplaintSuggestionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.department,
    required this.createdDate,
    required this.modifiedDate,
    required this.assignedToId,
    required this.authorId,
    required this.issueLoggedById,
    required this.issueLoggedByName,
  });

  factory ComplaintSuggestionItem.fromJson(Map<String, dynamic> json) {
    return ComplaintSuggestionItem(
      id: json['Id'],
      title: json['Title'],
      description: json['Description'],
      priority: json['Priority'],
      status: json['Status'],
      department: json['Department1'],
      assignedToId: json['Assignedto0Id'],
      authorId: json['AuthorId'],
      createdDate: DateTime.parse(json['Created']),
      modifiedDate: DateTime.parse(json['Modified']),
      issueLoggedById: json['IssueloggedbyId'],
      issueLoggedByName: json['Issue_x0020_logged_x0020_by1'],
    );
  }

  Map<String, dynamic> toJson() => {
    "Title": title,
    "Description": description,
    "Priority": priority,
    "Status": status,
    "Department1":department,
    "IssueloggedbyId": issueLoggedById,
    "Issue_x0020_logged_x0020_by1": issueLoggedByName
  };
}
