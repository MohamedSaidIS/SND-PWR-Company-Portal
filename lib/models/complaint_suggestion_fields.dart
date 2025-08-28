class ComplaintSuggestionFields {
  final String? channel;
  final String? title;
  final String? description;
  final String? priority;
  final String? status;

  ComplaintSuggestionFields({
    required this.channel,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
  });

  factory ComplaintSuggestionFields.fromJson(Map<String, dynamic> json) {
    return ComplaintSuggestionFields(
      channel: json['Channel'],
      title: json['Title'],
      description: json['Description'],
      priority: json['Priority'],
      status: json['Status'],
    );
  }
}
