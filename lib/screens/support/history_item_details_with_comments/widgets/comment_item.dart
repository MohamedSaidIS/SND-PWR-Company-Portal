import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../utils/export_import.dart';

class CommentItem extends StatelessWidget {
  final ItemComments comment;
  final Uint8List? userImage;
  final dynamic userInfo;

  const CommentItem(
      {required this.comment,
      required this.userImage,
      required this.userInfo,
      super.key});

  String _formatTimeAgo(DateTime dt, String locale) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return "${diff.inSeconds + 1}s";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return DateFormat("MMM d", locale).format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final locale = context.currentLocale();
    final isCurrentUser = comment.author.email == userInfo.mail;

    return commentTile(comment.author.name, comment.text, _formatTimeAgo(comment.createdDate!, locale), theme, isCurrentUser, comment, userImage);
  }

  Widget commentTile(
    String name,
    String commentStr,
    String time,
    ThemeData theme,
    bool isCurrentUser, ItemComments comment, Uint8List? userImage,
  ) {
    return Row(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commentUserImage(isCurrentUser, theme, name, userImage),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 8),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? theme.colorScheme.primary.withValues(alpha: 0.2)
                  : theme.colorScheme.secondary.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                commentText(theme, comment),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    ' $time',
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
