import 'dart:typed_data';

class AttachedBytes {  // to fetch mutli attached files
  final String fileName;
  final Uint8List? fileBytes;
  final String? fileBytesBase64;
  final String? fileType;

  AttachedBytes({
    required this.fileName,
    required this.fileBytes,
    required this.fileBytesBase64,
    required this.fileType
  });
}