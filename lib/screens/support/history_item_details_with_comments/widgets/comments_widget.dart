import 'dart:typed_data';

import 'package:company_portal/models/remote/item_comments.dart';
import 'package:company_portal/providers/comment_provider.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'comment_item.dart';
import 'no_comments.dart';

class CommentsWidget extends StatefulWidget {
  final CommentProvider commentProvider;
  final List<ItemComments> comments;
  final Uint8List? userImage;
  final dynamic userInfo;

  const CommentsWidget(
      {required this.comments,
      required this.userImage,
      required this.userInfo,
      required this.commentProvider,
      super.key});

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _commentHeader(theme),
        const SizedBox(height: 8),
        widget.commentProvider.loading
            ? const Center(child: CircularProgressIndicator())
            : widget.comments == [] || widget.comments.isEmpty
                ? const NoCommentsWidget()
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

  Widget _commentHeader(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Divider(
            color: theme.colorScheme.primary,
            thickness: 0.75,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              LineAwesomeIcons.comments_solid,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "Comments",
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
