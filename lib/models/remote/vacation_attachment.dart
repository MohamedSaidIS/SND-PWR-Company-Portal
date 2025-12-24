class VacationAttachment {
  final String fileNameWithExtension;
  final String fileType;
  final String file;

  VacationAttachment({
    required this.fileNameWithExtension,
    required this.fileType,
    required this.file,
  });

  Map<String, dynamic> toJson() => {
    "FileNameWithExtension": fileNameWithExtension,
    "FileType":fileType,
    "File": file,
  };
}
