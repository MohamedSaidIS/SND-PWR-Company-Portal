import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../utils/export_import.dart';

class AttachmentsViewer extends StatelessWidget {
  final AttachedBytes file;

  const AttachmentsViewer({super.key, required this.file});

  bool isDoc() {
    return file.fileName.toLowerCase().endsWith(".pdf") || file.fileName.toLowerCase().endsWith(".txt");
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(
              isDoc() ? Icons.picture_as_pdf : Icons.photo_outlined,
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
          if(file.fileBytes != null){
            isDoc()
                ? savePdf(context, file.fileBytes!, file.fileName)
                : showImagePopup(context, file.fileBytes!);
          }else if(file.fileBytesBase64 != null){
            isDoc()
                ? savePdf(context, base64Decode(file.fileBytesBase64!), file.fileName)
                : showImagePopup(context, base64Decode(file.fileBytesBase64!));
          }

        }, style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
            child: Text(local.view,style: const TextStyle(fontSize: 14,color: Colors.blueAccent),))
      ],
    );
  }
}
Uint8List base64Decode(String source) => base64.decode(source);

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
      child: SizedBox(
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
    final local = context.local;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(title: local.pdfPreview, backBtn: true,),
        body: SfPdfViewer.memory(file));
  }
}
