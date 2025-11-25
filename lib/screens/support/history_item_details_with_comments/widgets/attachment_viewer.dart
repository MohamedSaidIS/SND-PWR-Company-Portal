import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../models/local/attached_file_info.dart';
import '../../../../utils/export_import.dart';

class AttachmentsViewer extends StatelessWidget {
  final AttachedBytes file;

  const AttachmentsViewer({super.key, required this.file});

  bool isPdf() {
    return file.fileName.toLowerCase().endsWith(".pdf");
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(
              isPdf() ? Icons.picture_as_pdf : Icons.photo_outlined,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
              size: 20,
            ),
            Text(
              file.fileName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.brown,
              ),
            ),
          ],
        ),
        TextButton(onPressed: () {
          isPdf()
              ? savePdf(context, file.fileBytes, file.fileName)
              : showImagePopup(context, file.fileBytes);
        }, style: TextButton.styleFrom(
          padding: const EdgeInsets.only(right: 10, top: 5),
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
            child: const Text("View",style: TextStyle(fontSize: 14,color: Colors.blueAccent),))
      ],
    );
  }
}

void savePdf(BuildContext context, Uint8List pdfBytes, String fileName) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfPreviewScreen(file: pdfBytes),
    ),
  );
}

void showImagePopup(BuildContext context, Uint8List imageBytes) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: 500, // adjust as needed
        child: Column(
          children: [
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: PhotoView(
                imageProvider: MemoryImage(imageBytes),
                backgroundDecoration:
                    const BoxDecoration(color: Colors.transparent),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3.0,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class PdfPreviewScreen extends StatelessWidget {
  final Uint8List file;

  const PdfPreviewScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(title: const Text("PDF Preview")),
        body: SfPdfViewer.memory(file));
  }
}
