import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class SendCommentWidget extends StatelessWidget {
  final String itemId, commentCall;

  const SendCommentWidget(
      {super.key, required this.itemId, required this.commentCall});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SendCommentController(),
      builder: (context, _) {
        final allUsersProvider = context.watch<AllOrganizationUsersProvider>();
        final mentionUsers =
            allUsersProvider.allUsers.map((u) => u.toMap()).toList();
        final theme = context.theme;

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(15),

            ),
            child: SendCommentMentionsField(
              mentionUsers: mentionUsers,
              itemId: itemId,
              commentCall: commentCall,
            ),
          ),
        );
      },
    );
  }
}
