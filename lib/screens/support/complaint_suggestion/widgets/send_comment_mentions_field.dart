import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_notifier.dart';
import '../../history_item_details_with_comments/controller/send_comment_controller.dart';

class SendCommentMentionsField extends StatelessWidget {
  final List<Map<String, dynamic>> mentionUsers;
  final String itemId, commentCall;
  const SendCommentMentionsField({required this.mentionUsers, required this.itemId, required this.commentCall, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SendCommentController>();
    final theme = context.theme;
    final local = context.local;

    return  FlutterMentions(
      key: controller.mentionsKey,
      maxLines: 3,
      minLines: 1,
      suggestionPosition: SuggestionPosition.Top,
      suggestionListHeight: 150,
      suggestionListDecoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)],
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
        hintText: local.addComment,
        suffixIcon: AnimatedScale(
          duration: const Duration(milliseconds: 300),
          scale: controller.isBouncing ? 1.5 : 1.0,
          curve: Curves.elasticOut,
          child: IconButton(
            icon: controller.isSending
                ? SizedBox(
              height: 20,
              width: 20,
              child: AppNotifier.loadingWidget(theme),
            )
                : Icon(Icons.send, color: theme.colorScheme.secondary),
            onPressed: controller.isSending
                ? null
                : () => controller.sendComment(
              context: context,
              itemId: itemId,
              commentCall: commentCall,
              mentionUsers: mentionUsers,
            ),
          ),
        ),
      ),
      mentions: [
        Mention(
          trigger: "@",
          style: const TextStyle(
            color: Color(0xFF2657AA),
            fontWeight: FontWeight.w500,
          ),
          data: mentionUsers,
          suggestionBuilder: (data) => ListTile(
            title: Text(
              "${data['display']}",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            subtitle: Text(
              "${data['mail']}",
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 12,
              ),
            ),
            leading: const Image(
              image: AssetImage("assets/images/grey_avatar.png"),
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
