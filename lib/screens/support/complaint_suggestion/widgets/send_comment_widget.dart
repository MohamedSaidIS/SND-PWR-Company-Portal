import 'package:company_portal/screens/support/complaint_suggestion/widgets/send_comment_mentions_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/all_organization_users_provider.dart';
import '../../../../../utils/context_extensions.dart';
import '../../history_item_details_with_comments/controller/send_comment_controller.dart';

class SendCommentWidget extends StatelessWidget {
  final String itemId, commentCall;

  const SendCommentWidget({super.key, required this.itemId, required this.commentCall});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SendCommentController(),
      builder: (context, _) {
        final allUsersProvider = context.watch<AllOrganizationUsersProvider>();
        final mentionUsers = allUsersProvider.allUsers.map((u) => u.toMap()).toList();
        final theme = context.theme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)],
              ),
              child: SendCommentMentionsField(mentionUsers: mentionUsers, itemId: itemId, commentCall: commentCall),
            ),
          ),
        );
      },
    );
  }
}
