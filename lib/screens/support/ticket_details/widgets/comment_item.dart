import 'dart:typed_data';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final locale = context.currentLocale();
    final isCurrentUser = comment.author.email == userInfo.mail;

    return Row(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentUserImage(isCurrentUser: isCurrentUser,userImage: userImage, name: comment.author.name),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding:
            const EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 8),
            decoration: BoxDecoration(
              color: (isCurrentUser ?  theme.colorScheme.primary : theme.colorScheme.secondary).withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.author.name,
                  style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Comment(comment: comment),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    ' ${DatesHelper.formatTimeAgo(comment.createdDate!, locale)}',
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
