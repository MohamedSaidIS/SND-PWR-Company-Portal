import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class HistoryItemDetails extends StatefulWidget {
  final String modifiedDate, createdDate, commentCall;
  final String? itemId,
      type,
      title,
      description,
      status,
      priority,
      area,
      purpose;
  final List<String>? app;
  final Uint8List? userImage;
  final dynamic userInfo;

  const HistoryItemDetails({
    required this.itemId,
    required this.title,
    required this.description,
    required this.modifiedDate,
    required this.createdDate,
    required this.status,
    required this.priority,
    required this.commentCall,
    this.app,
    this.type,
    required this.purpose,
    required this.area,
    required this.userInfo,
    required this.userImage,
    super.key,
  });

  @override
  State<HistoryItemDetails> createState() => _HistoryItemDetailsState();
}

class _HistoryItemDetailsState extends State<HistoryItemDetails> {
  final ScrollController _attachmentsController = ScrollController();

  @override
  void dispose() {
    _attachmentsController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final commentProvider = context.read<CommentProvider>();
      final attachmentProvider = context.read<AttachmentsProvider>();
      if (widget.commentCall == "Dynamics") {
        commentProvider.getDynamicsComments(widget.itemId!, widget.commentCall);
        attachmentProvider.getAttachments(widget.itemId!, widget.commentCall);
      } else {
        commentProvider.getComments(widget.itemId!, widget.commentCall);
        attachmentProvider.getAttachments(widget.itemId!, widget.commentCall);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = context.watch<CommentProvider>();
    final comments = commentProvider.comments;
    final attachmentProvider = context.watch<AttachmentsProvider>();
    final attachments = attachmentProvider.fileBytes;

    final theme = context.theme;
    final local = context.local;
    return Portal(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.issue_details,
          backBtn: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleWidget(widget.title ?? "-", theme, widget.status ?? "-"),
                        const SizedBox(height: 24),
                        descriptionWidget(widget.description ?? "-", theme, widget.priority ?? "-", local),
                        const SizedBox(height: 24),
                        attachmentsWidget(attachmentProvider, attachments, theme, local, _attachmentsController),
                        const SizedBox(height: 24),
                        timeWidget(widget.createdDate, widget.modifiedDate.toString(), local),
                        const SizedBox(height: 10),
                        CommentsWidget(
                          comments: comments,
                          userImage: widget.userImage,
                          userInfo: widget.userInfo,
                          commentProvider: commentProvider,
                        ),
                        const SizedBox(height: 24),
                        SendCommentWidget(
                          itemId: widget.itemId!,
                          commentCall: widget.commentCall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


