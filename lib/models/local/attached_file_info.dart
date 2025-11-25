import 'dart:typed_data';

class AttachedBytes {  // to fetch mutli attached files
  final String fileName;
  final Uint8List fileBytes;

  AttachedBytes({
    required this.fileName,
    required this.fileBytes,
  });
}

class AttachedFile{
  final String fileName;
  final String filePath;

  AttachedFile({
    required this.fileName,
    required this.filePath,
  });
}