import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class Comment extends StatelessWidget {
  final ItemComments comment;

  const Comment({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text.rich(
        TextSpan(
          children: comment.parts.map((part) {
            if (part is Mention) {
              return TextSpan(
                text: "@${part.name} ",
                style: const TextStyle(
                  color: Color(0xFF3474EA),
                  fontWeight: FontWeight.w500,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AppNotifier.logWithScreen(
                        "CommentItem Screen", "Clicked on mention: ${part.name}");
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
