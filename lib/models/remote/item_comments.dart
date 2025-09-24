import 'package:html_unescape/html_unescape.dart';

class ItemComments {
  final CommentAuthor author;
  final DateTime? createdDate;
  final String? id;
  final bool isLikedByUser;
  final bool isReply;
  final int itemId;
  final int likeCount;
  final List<Mention> mentions;
  final String text;
  final String parsedText;
  final List parts;

  ItemComments({
    required this.author,
    required this.createdDate,
    required this.id,
    required this.isLikedByUser,
    required this.isReply,
    required this.itemId,
    required this.likeCount,
    required this.mentions,
    required this.text,
    required this.parsedText,
    required this.parts,
  });

  factory ItemComments.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();
    final rawText = json["text"] ?? "";
    final decoded = unescape.convert(rawText);

    final mentionsList = (json["mentions"] as List?) ?? [];
    final mentions = mentionsList
        .asMap()
        .entries
        .map((entry) => Mention.fromJson(entry.value, entry.key))
        .toList();

    // استبدال mentions placeholders
    final parts = <dynamic>[]; // can hold String or Mention
    var remaining = decoded;

    for (var mention in mentions) {
      final placeholder = "@mention{${mention.index}}";
      final idx = remaining.indexOf(placeholder);

      if (idx != -1) {
        if (idx > 0) {
          parts.add(remaining.substring(0, idx)); // add normal text
        }
        parts.add(mention); // add mention separately
        remaining = remaining.substring(idx + placeholder.length);
      }
    }

    if (remaining.isNotEmpty) {
      parts.add(remaining);
    }

    // rebuild plain text (without placeholders, with mention names)
    final plainText = parts.map((p) {
      if (p is Mention) {
        return "@${p.name}";
      } else {
        return p.toString();
      }
    }).join("");

    return ItemComments(
      author: CommentAuthor.fromJson(json["author"]),
      createdDate: DateTime.parse(json["createdDate"]),
      id: json["id"],
      isLikedByUser: json["isLikedByUser"],
      isReply: json["isReply"],
      itemId: json["itemId"],
      likeCount: json["likeCount"],
      mentions: mentions,
      text: rawText,
      parsedText: plainText,
      parts: parts,
    );
  }
}

class CommentAuthor {
  final int id;
  final String email;
  final String name;

  CommentAuthor({
    required this.id,
    required this.email,
    required this.name,
  });

  factory CommentAuthor.fromJson(Map<String, dynamic> json) {
    return CommentAuthor(
      id: json["id"],
      email: json["email"],
      name: json["name"],
    );
  }
}

class Mention {
  final int index;
  final int id;
  final String name;
  final String email;

  Mention({
    required this.index,
    required this.id,
    required this.name,
    required this.email,
  });

  factory Mention.fromJson(Map<String, dynamic> json, int index) {
    return Mention(
      index: index,
      id: json["id"],
      name: json["name"],
      email: json["email"],
    );
  }
}
