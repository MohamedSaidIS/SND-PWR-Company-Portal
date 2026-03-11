class Attachment {
  final String id;
  final String fileName;

  Attachment({
    required this.id,
    required this.fileName,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['odata.id'],
      fileName: json['FileName'],
    );
  }
}
