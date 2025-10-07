import 'dart:typed_data';

import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../models/remote/item_comments.dart';
import '../../../../../utils/app_notifier.dart';


class CommentItem extends StatelessWidget {
  final ItemComments comment;
  final Uint8List? userImage;
  final dynamic userInfo;

  const CommentItem({required this.comment,
    required this.userImage,
    required this.userInfo,
    super.key});


  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return "${diff.inSeconds+1}s";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return DateFormat("MMM d").format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isCurrentUser = comment.author.email == userInfo.mail;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 2),
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? theme.colorScheme.primary.withValues(alpha:0.2)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCurrentUser) _buildUserInfoRow(
              theme,
              image: const Image(
                image: AssetImage("assets/images/grey_avatar.png"),
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              ),
            ),
            if (isCurrentUser) _buildUserInfoRow(
              theme,
              image: Image.memory(
                userImage!,
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            _buildRichText(theme),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _formatTimeAgo(comment.createdDate!),
                  style: TextStyle(
                    color: theme.colorScheme.primary.withValues(alpha:0.6),
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(ThemeData theme, {required Image image}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: image,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              comment.author.name,
              softWrap: true,
              maxLines: null,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRichText(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text.rich(
        TextSpan(
          children: comment.parts.map((part) {
            if (part is Mention) {
              return TextSpan(
                text: "@${part.name} ",
                style: const TextStyle(
                  color: Color(0xFF2657AA),
                  fontWeight: FontWeight.w500,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AppNotifier.logWithScreen("CommentItem Screen","Clicked on mention: ${part.name}");
                  },
              );
            } else {
              return TextSpan(
                text: "$part ",
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                ),
              );
            }
          }).toList(),
        ),
      ),
    );
  }
}


