class AppNotification {
  final String id;
  final String? title;
  final String? body;
  final Map<String, dynamic> data;
  final DateTime date;
  bool isRead;

  AppNotification({
    required this.id,
    this.title,
    this.body,
    required this.data,
    required this.date,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() =>{
    'id': id,
    'title': title,
    'body': body,
    'data': data,
    'date': date.toIso8601String(),
    'isRead': isRead,
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      data: Map<String, dynamic>.from(json['data']),
      date: DateTime.parse(json['date']),
      isRead: json['isRead'] ?? false,
    );
  }
}
