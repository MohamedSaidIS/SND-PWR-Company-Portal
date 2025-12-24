import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';

class PreviousRequestAttachments extends StatelessWidget {
  final PreviousRequests item;
  const PreviousRequestAttachments({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final local = context.local;

    return item.attachments.isNotEmpty? Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(local.attachments,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold)),
          ListView.builder(
              itemCount: item.attachments.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final attachment = item.attachments[index];
                return AttachmentsViewer(file: attachment);
              })
        ],
      ),
    ) : const SizedBox.shrink();
  }
}
