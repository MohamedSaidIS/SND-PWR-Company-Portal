import 'dart:typed_data';
import 'package:company_portal/common/custom_app_bar.dart';
import 'package:company_portal/providers/comment_provider.dart';
import 'package:company_portal/screens/support/complaint_suggestion/widgets/send_comment_widget.dart';
import 'package:company_portal/screens/support/complaint_suggestion/widgets/time_widget.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/app_notifier.dart';
import '../widgets/comments_widget.dart';
import '../../common_widgets/priority_badge.dart';
import '../../common_widgets/status_badge.dart';

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
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final commentProvider = context.read<CommentProvider>();

      (widget.commentCall == "Dynamics")
          ? commentProvider.getDynamicsComments(widget.itemId!, widget.commentCall)
          : commentProvider.getComments(widget.itemId!, widget.commentCall);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = context.watch<CommentProvider>();
    final comments = commentProvider.comments;

    final theme = context.theme;
    final local = context.local;

    AppNotifier.logWithScreen(
        "HistoryItemDetails Screen", "Image: ${widget.userImage != null}");

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
                  padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PriorityBadge(priority: widget.priority ?? "-"),
                            const SizedBox(width: 2),
                            StatusBadge(status: widget.status ?? "-"),
                          ],
                        ),
                      ),
                      _titleWidget(widget.title ?? "-", theme),
                      const SizedBox(height: 12),
                      _descriptionWidget(widget.description ?? "-", theme),
                      const SizedBox(height: 20),
                      TimeWidget(
                        icon: Icons.access_time,
                        label: "Created At",
                        value: widget.createdDate,
                      ),
                      TimeWidget(
                        icon: Icons.update,
                        label: "Last Modified",
                        value: widget.modifiedDate.toString(),
                      ),
                      const SizedBox(height: 10),
                      CommentsWidget(
                        comments: comments,
                        userImage: widget.userImage,
                        userInfo: widget.userInfo,
                        commentProvider: commentProvider,
                      ),
                    ],
                  ),
                ),
              ),
              SendCommentWidget(
                itemId: widget.itemId!,
                commentCall: widget.commentCall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _titleWidget(String title, ThemeData theme) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 19,
      color: theme.colorScheme.secondary,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _descriptionWidget(String description, ThemeData theme) {
  return Text(
    description,
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: theme.colorScheme.primary,
      height: 1.4,
    ),
  );
}
