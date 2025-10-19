import 'package:company_portal/providers/all_organization_users_provider.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';

import '../../../../../models/remote/complaint_suggestion_item.dart';
import '../../../../../providers/complaint_suggestion_provider.dart';
import '../../../../../providers/sp_ensure_user.dart';
import '../../../../../utils/app_notifier.dart';


class SendCommentWidget extends StatefulWidget {
  final ComplaintSuggestionItem item;

  const SendCommentWidget({super.key, required this.item});

  @override
  State<SendCommentWidget> createState() => _SendCommentWidgetState();
}

class _SendCommentWidgetState extends State<SendCommentWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  final _commentController = TextEditingController();
  bool _isSending = false;
  bool _isBouncing = false;

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<ComplaintSuggestionProvider>();
  //     context.read<SPEnsureUserProvider>();
  //
  //     final allUsersProvider = context.read<AllOrganizationUsersProvider>();
  //     allUsersProvider.getAllUsers();
  //   });
  //   super.initState();
  // }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final complaintCommentsProvider =
        context.watch<ComplaintSuggestionProvider>();
    final allUsersProvider = context.watch<AllOrganizationUsersProvider>();
    final enSureUserProvider = context.watch<SPEnsureUserProvider>();
    final allUsers = allUsersProvider.allUsers;
    final mentionUsers = allUsers.map((user) => user.toMap()).toList();

    final theme = context.theme;
    final local = context.local;

    Future<List<Map<String, dynamic>>> prepareMentions(
        List<Map<String, dynamic>> mentionUsers,
        SPEnsureUserProvider spEnsureUserProvider) async {
      List<Map<String, dynamic>> mentions = [];

      AppNotifier.logWithScreen(
          "SendComment Screen", "Mention Users: $mentionUsers");
      for (var user in mentionUsers) {
        final email = user['mail'];
        final displayName = user['display'];
        AppNotifier.logWithScreen("SendComment Screen", "EMAIL: $email");
        if (email != null) {
          await spEnsureUserProvider.fetchITSiteEnsureUser(email, context);
          int? id = spEnsureUserProvider.itEnsureUser?.id;
          AppNotifier.logWithScreen("SendComment Screen", "ID: $id");
          if (id != null) {
            mentions.add({
              "id": id,
              "email": email,
              "loginName": "i:0#.f|membership|$email",
              "name": displayName,
            });
          }
        }
      }

      AppNotifier.logWithScreen("SendComment Screen", "Mentions: $mentions");
      return mentions;
    }

    List<Map<String, dynamic>> extractMentionsByDisplay(
      String text,
      List<Map<String, dynamic>> mentionUsers,
    ) {
      final regex = RegExp(r'@(?:.+?\(([^)]+)\)|([A-Za-z0-9 ()._-]+))(?=\s|$)');
      final matches = regex.allMatches(text);

      for (var element in mentionUsers) {
        AppNotifier.logWithScreen(
            "SendComment Screen", "Mention Element: $element");
      }

      List<Map<String, dynamic>> foundMentions = [];

      for (final match in matches) {
        AppNotifier.logWithScreen(
            "SendComment Screen", "Match: ${match.group(1)}");
        final displayName = match.group(1)?.trim(); // "Amira Mohamed"
        if (displayName != null) {
          final user = mentionUsers.firstWhere(
            (u) => (u['display'] as String)
                .toLowerCase()
                .contains(displayName.toLowerCase()),
            orElse: () => {},
          );
          AppNotifier.logWithScreen("SendComment Screen", "Match User: $user");
          if (user.isNotEmpty) {
            foundMentions.add(user);
          }
        }
      }

      return foundMentions;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 8.0,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
            color: theme.colorScheme.surface,
            boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)],
          ),
          child: FlutterMentions(
            key: key,
            maxLines: 3,
            minLines: 1,
            suggestionPosition: SuggestionPosition.Top,
            suggestionListHeight: 150,
            suggestionListDecoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)],
            ),
            decoration: InputDecoration(
              fillColor: Colors.white,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.only(left: 15, top: 10, bottom: 10),
              hintText: local.addComment,
              suffixIcon: AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: _isBouncing ? 1.5 : 1.0,
                curve: Curves.elasticOut,
                child: IconButton(
                  onPressed: () async {
                    if (_isSending) return;
                    setState(() => _isSending = true);

                    final rawText =
                        key.currentState?.controller?.text.trim() ?? "";

                    if (rawText.isNotEmpty) {
                      setState(() => _isSending = true);

                      String commentText = rawText;

                      final extractedUsers =
                          extractMentionsByDisplay(rawText, mentionUsers);
                      AppNotifier.logWithScreen("SendComment Screen",
                          "Extracted Users: $extractedUsers");

                      for (int i = 0; i < extractedUsers.length; i++) {
                        final displayName = extractedUsers[i]['display'];
                        if (displayName != null && displayName.isNotEmpty) {
                          commentText = commentText.replaceAll(
                            "@$displayName",
                            "@mention&#123;$i&#125;",
                          );
                          AppNotifier.logWithScreen("SendComment Screen",
                              "Comment Text: $commentText");
                        }
                      }

                      final mentions = await prepareMentions(
                          extractedUsers, enSureUserProvider);

                      bool sentSuccess =
                          await complaintCommentsProvider.postComments(
                        "${widget.item.id}",
                        commentText,
                        mentions: mentions,
                      );
                      if (sentSuccess && context.mounted) {
                        key.currentState?.controller?.clear();
                        FocusScope.of(context).unfocus();

                        setState(() => _isBouncing = true);
                        await Future.delayed(const Duration(milliseconds: 300));
                        setState(() => _isBouncing = false);
                      }

                      setState(() => _isSending = false);

                    }
                  },
                  icon: _isSending
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.secondary,
                          ),
                        )
                      : Icon(Icons.send, color: theme.colorScheme.secondary),
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
                suggestionBuilder: (data) {
                  return ListTile(
                    title: Text(
                      "${data['display']}",
                      style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    subtitle: Text(
                      "${data['mail']}",
                      style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.normal,
                          fontSize: 12),
                    ),
                    leading: const Image(
                      image: AssetImage("assets/images/grey_avatar.png"),
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
