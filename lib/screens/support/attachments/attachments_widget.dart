import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class AttachmentsWidget extends StatefulWidget {
  final String itemId;
  final String commentCall;

  const AttachmentsWidget(
      {required this.itemId, required this.commentCall, super.key});

  @override
  State<AttachmentsWidget> createState() => _AttachmentsWidgetState();
}

class _AttachmentsWidgetState extends State<AttachmentsWidget> {
  final ScrollController _attachmentsController = ScrollController();
  late ThemeData theme;
  late AppLocalizations local;
  late AttachmentsProvider attachmentProvider;
  List<AttachedBytes>? attachments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var attachmentProvider = context.read<AttachmentsProvider>();
      await attachmentProvider.getAttachments(
          widget.itemId, widget.commentCall);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = context.theme;
    local = context.local;
    attachmentProvider = context.watch<AttachmentsProvider>();
    attachments = attachmentProvider.fileBytes;
  }

  @override
  void dispose() {
    _attachmentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TicketSectionTitle(text: local.attachments),
        const SizedBox(height: 8),
        attachmentProvider.loading
            ? AppNotifier.loadingWidget(theme)
            : attachments == null || attachments!.isEmpty
                ? const NoAttachments()
                : SizedBox(
                    height: (22 * (attachments!.length)).toDouble(),
                    child: Scrollbar(
                      controller: _attachmentsController,
                      thumbVisibility: attachments!.length > 2 ? true : false,
                      child: ListView.builder(
                          controller: _attachmentsController,
                          physics: attachments!.length > 2
                              ? const AlwaysScrollableScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          itemCount: attachments!.length,
                          itemBuilder: (context, index) {
                            return AttachmentsViewer(
                              file: attachments![index],
                            );
                          }),
                    ),
                  ),
      ],
    );
  }
}
