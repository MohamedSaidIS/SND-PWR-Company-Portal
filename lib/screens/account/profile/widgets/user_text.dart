import 'package:flutter/material.dart';

class UserText extends StatelessWidget {
  final String textStr;
  final TextStyle textStyle;

  const UserText({
    super.key,
    required this.textStr,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (textStr.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        textStr,
        style: textStyle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }
}
