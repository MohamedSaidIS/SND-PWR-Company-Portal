import 'package:company_portal/models/remote/all_organization_user.dart';
import 'package:company_portal/providers/all_organization_users_provider.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';

import '../../../../models/remote/complaint_suggestion.dart';
import '../../../../providers/complaint_suggestion_provider.dart';
import '../../../../providers/sp_ensure_user.dart';
import '../../../../utils/app_notifier.dart';

class SendCommentWidget extends StatefulWidget {
  final ComplaintSuggestion item;

  const SendCommentWidget({super.key, required this.item});

  @override
  State<SendCommentWidget> createState() => _SendCommentWidgetState();
}

class _SendCommentWidgetState extends State<SendCommentWidget> {
  final GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  final _commentController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComplaintSuggestionProvider>();
      context.read<SPEnsureUserProvider>();

      final allUsersProvider = context.read<AllOrganizationUsersProvider>();
      allUsersProvider.getAllUsers();
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
    final complaintCommentsProvider = context.watch<ComplaintSuggestionProvider>();
    final allUsersProvider = context.watch<AllOrganizationUsersProvider>();
    final enSureUserProvider = context.watch<SPEnsureUserProvider>();
    final allUsers = allUsersProvider.allUsers;
    final mentionUsers = allUsers.map((user) => user.toMap()).toList();

    final theme = context.theme;
    final local = context.local;

    Future<List<Map<String, dynamic>>> prepareMentions(List<Map<String, dynamic>> mentionUsers, SPEnsureUserProvider spEnsureUserProvider) async {

      List<Map<String, dynamic>> mentions = [];

      AppNotifier.logWithScreen("SendComment Screen","Mention Users: $mentionUsers");
      for (var user in mentionUsers) {
        final email = user['mail'];
        final displayName = user['display'];
        AppNotifier.logWithScreen("SendComment Screen","EMAIL: $email");
        if (email != null) {

          await spEnsureUserProvider.fetchEnsureUser(email);
          int? id = spEnsureUserProvider.ensureUser?.id;
          AppNotifier.logWithScreen("SendComment Screen","ID: $id");
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

      AppNotifier.logWithScreen("SendComment Screen","Mentions: $mentions");
      return mentions;
    }
    List<Map<String, dynamic>> extractMentionsByDisplay(String text, List<Map<String, dynamic>> mentionUsers,) {
      final regex = RegExp(r'@([A-Za-z0-9 ()._-]+)');
      final matches = regex.allMatches(text);

      mentionUsers.forEach((element) => AppNotifier.logWithScreen("SendComment Screen","Mention Element: $element"));

      List<Map<String, dynamic>> foundMentions = [];

      for (final match in matches) {
        AppNotifier.logWithScreen("SendComment Screen","Match: ${match.group(1)}");
        final displayName = match.group(1)?.trim(); // "Amira Mohamed"
        if (displayName != null) {
          final user = mentionUsers.firstWhere(
                (u) => u['display'] == displayName,
            orElse: () => {},
          );
          AppNotifier.logWithScreen("SendComment Screen","Match User: $user");
          if (user.isNotEmpty) {
            foundMentions.add(user);
          }
        }
      }

      return foundMentions;
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: theme.colorScheme.background,
            boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)],
          ),
          child: FlutterMentions(
            key: key,
            maxLines: 3,
            minLines: 1,
            suggestionPosition: SuggestionPosition.Top,
            suggestionListHeight: 150,
            suggestionListDecoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)],
            ),
            decoration: InputDecoration(
              fillColor: Colors.white,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.only(left: 15, top: 10, bottom: 20),
              hintText: "Add a comment",
              suffixIcon: IconButton(
                onPressed: () async {
                  final rawText = key.currentState?.controller?.text.trim() ?? "";

                  if (rawText.isNotEmpty) {
                    String commentText = rawText;

                    final extractedUsers = extractMentionsByDisplay(rawText, mentionUsers);
                    AppNotifier.logWithScreen("SendComment Screen","Extracted Users: $extractedUsers");

                    for (int i = 0; i < extractedUsers.length; i++) {
                      final displayName = extractedUsers[i]['display'];
                      if (displayName != null && displayName.isNotEmpty) {
                        commentText = commentText.replaceAll(
                          "@$displayName",
                          "@mention&#123;$i&#125;",
                        );
                        AppNotifier.logWithScreen("SendComment Screen","Comment Text: $commentText");
                      }
                    }

                    final mentions = await prepareMentions(extractedUsers, enSureUserProvider);

                    bool sentSuccess = await complaintCommentsProvider.postComments(
                      "${widget.item.id}",
                      commentText,
                      mentions: mentions,
                    );
                    if (sentSuccess) {
                      key.currentState?.controller?.clear();
                      FocusScope.of(context).unfocus();
                    } else if (complaintCommentsProvider.error != null && complaintCommentsProvider.error == "401") {
                      AppNotifier.loginAgain(context);
                    }
                  }
                },
                icon: Icon(Icons.send, color: theme.colorScheme.secondary),
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

class EnsureUser {
  final String? id;
  final String? email;
  final int? enSuerId;

  const EnsureUser({
    required this.id,
    required this.email,
    required this.enSuerId,
  });
}
