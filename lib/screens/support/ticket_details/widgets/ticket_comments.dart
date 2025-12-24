import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class TicketComments extends StatefulWidget {
  final CommentProvider commentProvider;
  final List<ItemComments> comments;
  final Uint8List? userImage;
  final dynamic userInfo;

  const TicketComments(
      {required this.comments,
      required this.userImage,
      required this.userInfo,
      required this.commentProvider,
      super.key});

  @override
  State<TicketComments> createState() => _TicketCommentsState();
}

class _TicketCommentsState extends State<TicketComments> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TicketSectionTitle(text: local.comments),
        const SizedBox(height: 16),
        widget.commentProvider.loading
            ? AppNotifier.loadingWidget(theme)
            : widget.comments == [] || widget.comments.isEmpty
                ? const NoComments()
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.comments.length,
                    itemBuilder: (context, index) {
                      return CommentItem(
                        comment: widget.comments[index],
                        userImage: widget.userImage,
                        userInfo: widget.userInfo,
                      );
                    },
                  ),
      ],
    );
  }
}
