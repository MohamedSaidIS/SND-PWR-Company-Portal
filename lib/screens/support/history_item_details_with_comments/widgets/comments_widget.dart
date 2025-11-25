import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../utils/export_import.dart';

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
        sectionTitle("Comments", theme),
        const SizedBox(height: 16),
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
}

