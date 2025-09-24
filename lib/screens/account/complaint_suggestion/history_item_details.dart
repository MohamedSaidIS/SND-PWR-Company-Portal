import 'dart:typed_data';

import 'package:company_portal/common/custom_app_bar.dart';
import 'package:company_portal/screens/account/complaint_suggestion/widgets/comments_widget.dart';
import 'package:company_portal/screens/account/complaint_suggestion/widgets/priority_badge.dart';
import 'package:company_portal/screens/account/complaint_suggestion/widgets/status_badge.dart';
import 'package:company_portal/screens/account/complaint_suggestion/widgets/time_widget.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/remote/complaint_suggestion.dart';
import '../../../providers/complaint_suggestion_provider.dart';

class HistoryItemDetails extends StatefulWidget {
  final ComplaintSuggestion item;
  final Uint8List? userImage;
  final dynamic userInfo;

  const HistoryItemDetails(
      {required this.item,
      required this.userImage,
      required this.userInfo,
      super.key});

  @override
  State<HistoryItemDetails> createState() => _HistoryItemDetailsState();
}

class _HistoryItemDetailsState extends State<HistoryItemDetails> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final complaintCommentsProvider = context.read<ComplaintSuggestionProvider>();

      complaintCommentsProvider.getComments("${widget.item.id}");
    });
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final complaintCommentsProvider =
        context.watch<ComplaintSuggestionProvider>();
    final comments = complaintCommentsProvider.comments;

    final theme = context.theme;
    final local = context.local;

    print("Image: ${widget.userImage != null}");

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: local.issue_details,
        backBtn: true,
      ),
      body: Column(
        children: [
          // الجزء العلوي (expandable)
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
                        PriorityBadge(priority: widget.item.fields?.priority ?? "-"),
                        const SizedBox(width: 2),
                        StatusBadge(status: widget.item.fields?.status ?? "-"),
                      ],
                    ),
                  ),
                  _titleWidget(widget.item.fields?.title ?? "-", theme),
                  const SizedBox(height: 12),
                  _descriptionWidget(widget.item.fields?.description ?? "-", theme),
                  const SizedBox(height: 20),
                  TimeWidget(
                    icon: Icons.access_time,
                    label: "Created At",
                    value: widget.item.createdDateTime.toString(),
                  ),
                  TimeWidget(
                    icon: Icons.update,
                    label: "Last Modified",
                    value: widget.item.lastModifiedDateTime.toString(),
                  ),
                  const SizedBox(height: 10),
                  CommentsWidget(
                    comments: comments,
                    userImage: widget.userImage,
                    userInfo: widget.userInfo,
                    item: widget.item,
                    complaintCommentsProvider: complaintCommentsProvider,
                  ),
                ],
              ),
            ),
          ),

          // الجزء السفلي (ثابت)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: theme.colorScheme.background,
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)],
            ),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 10, top: 10),
                hintText: "Add a comment",
                suffixIcon: IconButton(
                  onPressed: () async{
                    final comment = _commentController.text.trim();
                    if (comment.isNotEmpty) {
                      bool sentSuccess = await complaintCommentsProvider.postComments("${widget.item.id}", comment);
                      if(sentSuccess){
                        _commentController.clear();
                      }
                    }
                  },
                  icon: Icon(Icons.send, color: theme.colorScheme.primary),
                ),
              ),
            ),
          ),
        ],
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
