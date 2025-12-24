import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class CommentUserImage extends StatelessWidget {
  final bool isCurrentUser;
  final String name;
  final Uint8List? userImage;
  const CommentUserImage({super.key, required this.isCurrentUser, required this.name, this.userImage});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: RepaintBoundary(
          child: CircleAvatar(
            radius: 20,
            backgroundColor: (isCurrentUser
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary)
                .withValues(alpha: 0.2),
            backgroundImage: isCurrentUser ? MemoryImage(userImage!) : null,
            child: isCurrentUser
                ? null
                : Text(
              extractInitialsFromParentheses(name),
              style: const TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  String extractInitialsFromParentheses(String fullName) {
    final regex = RegExp(r'\((.*?)\)');
    final match = regex.firstMatch(fullName);

    if (match != null) {
      final inside = match.group(1)!.trim();
      final parts = inside.split(" ");

      if (parts.length >= 2) {
        return "${parts[0][0]}${parts[1][0]}".toUpperCase();
      } else {
        return inside.substring(0, 1).toUpperCase();
      }
    }

    return fullName.isNotEmpty ? fullName.substring(0, 2).toUpperCase() : "?";
  }

}
