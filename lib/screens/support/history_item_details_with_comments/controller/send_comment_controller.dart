import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';

import '../../../../providers/comment_provider.dart';
import '../../../../providers/sp_ensure_user.dart';
import '../../../../utils/app_notifier.dart';

class SendCommentController extends ChangeNotifier {
  final GlobalKey<FlutterMentionsState> mentionsKey = GlobalKey<FlutterMentionsState>();
  final TextEditingController textController = TextEditingController();
  bool isSending = false;
  bool isBouncing = false;

  void disposeController() {
    textController.dispose();
  }

  List<Map<String, dynamic>> extractMentionsByDisplay(
    String text,
    List<Map<String, dynamic>> mentionUsers,
  ) {
    final regex = RegExp(r'@(?:.+?\(([^)]+)\)|([A-Za-z0-9 ()._-]+))(?=\s|$)');
    final matches = regex.allMatches(text);

    for (var element in mentionUsers) {
      AppNotifier.logWithScreen(
          "SendComment Controller", "Mention Element: $element");
    }

    List<Map<String, dynamic>> foundMentions = [];

    for (final match in matches) {
      AppNotifier.logWithScreen(
          "SendComment Controller", "Match: ${match.group(1)}");
      final displayName = match.group(1)?.trim();
      if (displayName != null) {
        final user = mentionUsers.firstWhere(
          (u) => (u['display'] as String)
              .toLowerCase()
              .contains(displayName.toLowerCase()),
          orElse: () => {},
        );
        AppNotifier.logWithScreen(
            "SendComment Controller", "Match User: $user");
        if (user.isNotEmpty) {
          foundMentions.add(user);
        }
      }
    }
    return foundMentions;
  }

  Future<List<Map<String, dynamic>>> prepareMentions(
    List<Map<String, dynamic>> mentionUsers,
    SPEnsureUserProvider spEnsureUserProvider,
    BuildContext context,
  ) async {
    List<Map<String, dynamic>> mentions = [];

    AppNotifier.logWithScreen(
        "SendComment Controller", "Mention Users: $mentionUsers");
    for (var user in mentionUsers) {
      final email = user['mail'];
      final displayName = user['display'];
      AppNotifier.logWithScreen("SendComment Controller", "EMAIL: $email");
      if (email != null) {
        await spEnsureUserProvider.fetchITSiteEnsureUser(email, context);
        int? id = spEnsureUserProvider.itEnsureUser?.id;
        AppNotifier.logWithScreen("SendComment Controller", "ID: $id");
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

    AppNotifier.logWithScreen("SendComment Controller", "Mentions: $mentions");
    return mentions;
  }

  Future<void> sendComment({
    required BuildContext context,
    required String itemId,
    required String commentCall,
    required List<Map<String, dynamic>> mentionUsers,
  }) async {
    final commentProvider = context.read<CommentProvider>();
    final spEnsureUserProvider = context.read<SPEnsureUserProvider>();

    final rawText = mentionsKey.currentState?.controller?.text.trim() ?? "";
    if (rawText.isEmpty) return;

    isSending = true;
    notifyListeners();

    String commentText = rawText;
    final extractedUsers = extractMentionsByDisplay(rawText, mentionUsers);

    for (int i = 0; i < extractedUsers.length; i++) {
      final displayName = extractedUsers[i]['display'];
      if (displayName != null && displayName.isNotEmpty) {
        commentText =
            commentText.replaceAll("@$displayName", "@mention&#123;$i&#125;");
      }
    }

    final mentions = await prepareMentions(
      extractedUsers,
      spEnsureUserProvider,
      context,
    );

    final success = await commentProvider.sendComments(
      itemId,
      commentText,
      commentCall,
      mentions: mentions,
    );

    if (success) {
      mentionsKey.currentState?.controller?.clear();
      FocusScope.of(context).unfocus();
      isBouncing = true;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 300));
      isBouncing = false;
    }

    isSending = false;
    notifyListeners();
  }
}
