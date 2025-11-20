import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AttachmentWidget extends StatefulWidget {
  final Future<void> Function() pickFile;
  const AttachmentWidget({super.key, required this.pickFile});

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return InkWell(
      splashColor: Colors.black12,
      borderRadius: BorderRadius.circular(10),
      onTap:()async {
        await widget.pickFile();
      } ,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Icon(
              LineAwesomeIcons.paperclip_solid,
              color: theme.colorScheme.secondary,
            ),
            Text(local.attachFile)
          ],
        ),
      ),
    );
  }
}
