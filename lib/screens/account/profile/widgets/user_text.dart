import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/export_import.dart';

class UserInfoWidget extends StatelessWidget {
  final dynamic userInfo;

  const UserInfoWidget({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      key: ValueKey("${userInfo?.givenName ?? ''} ${userInfo?.surname ?? ''}"),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UserText(
          text: "${userInfo?.givenName ?? "-"} ${userInfo?.surname ?? "-"}",
          textStyle: theme.textTheme.displayLarge!,
        ),
        UserText(
          text: userInfo?.jobTitle ?? "-",
          textStyle: theme.textTheme.displayMedium!,
        ),
        UserText(
          text: userInfo?.mail ?? "-",
          textStyle: theme.textTheme.displaySmall!,
        ),
      ],
    );
  }
}

class UserText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  const UserText({super.key, required this.text, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        text,
        style: textStyle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class UserInfoLoading extends StatelessWidget {
  const UserInfoLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surface,
      highlightColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          skeletonBox(200, 18, theme),
          skeletonBox(150, 16, theme),
          skeletonBox(100, 14, theme),
        ],
      ),
    );

  }
  Widget skeletonBox(double width, double height, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

