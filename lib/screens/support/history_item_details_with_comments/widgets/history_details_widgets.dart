import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../models/local/attached_file_info.dart';
import '../../../../utils/export_import.dart';

Widget sectionTitle(String text, ThemeData theme) {
  return Text(
    text,
    style: TextStyle(
      color: theme.colorScheme.secondary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget titleWidget(
    String title,
    ThemeData theme,
    String status,
    ) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Tooltip(
          message: capitalizeWords(title),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            capitalizeWords(title),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 19,
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      StatusBadge(status: status)
    ],
  );
}

Widget descriptionWidget(String description, ThemeData theme, String priority,
    AppLocalizations local) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            local.description,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.primary,
              height: 1.4,
            ),
          ),
          PriorityBadge(priority: priority)
        ],
      ),
      const SizedBox(height: 6),
      Text(
        capitalize(description),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: theme.colorScheme.primary,
          height: 1.4,
        ),
      ),
    ],
  );
}

Widget attachmentsWidget(AttachmentsProvider attachmentProvider, List<AttachedBytes>? attachments, ThemeData theme, ScrollController attachmentsController){
  return attachmentProvider.loading
      ? const Center(child: CircularProgressIndicator())
      : Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionTitle("Attachments", theme),
      const SizedBox(height: 8),
      SizedBox(
        height: 100,
        child: Scrollbar(
        controller: attachmentsController,      // required


  thumbVisibility: attachments!.length > 4? true : false,
          child: ListView.builder(
              controller: attachmentsController,
              physics: attachments.length > 4? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
              itemCount: attachments.length,
              itemBuilder: (context, index) {
                return AttachmentsViewer(
                  file: attachments[index],
                );
              }),
        ),
      ),
    ],
  );
}

Widget timeWidget(String createdDate, String modifiedDate){
  return  Row(
    spacing: 30,
    children: [
      TimeWidget(
        icon: Icons.access_time,
        label: "Created At",
        value: createdDate,
      ),
      TimeWidget(
        icon: Icons.update,
        label: "Last Modified",
        value: modifiedDate.toString(),
      ),
    ],
  );
}

String capitalizeWords(String text) {
  if (text.isEmpty) return text;
  return text.split(" ").map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }).join(" ");
}

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

//////////////////////////////////////////////////// comments Widgets \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Widget commentUserImage(bool isCurrentUser, ThemeData theme, String name, Uint8List? userImage, ) {
  return Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: isCurrentUser
            ? theme.colorScheme.primary.withValues(alpha: 0.2)
            : theme.colorScheme.secondary.withValues(alpha: 0.2),
        child: isCurrentUser
            ? ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.memory(
            userImage!,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        )
            : Text(
          extractInitialsFromParentheses(name),
          style: const TextStyle(
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

Widget commentText(ThemeData theme, ItemComments comment) {
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
                  AppNotifier.logWithScreen("CommentItem Screen",
                      "Clicked on mention: ${part.name}");
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