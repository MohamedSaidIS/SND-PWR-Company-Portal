import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/export_import.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic userInfo;
  final Uint8List? userImage;
  final File? pickedImage;
  final UserImageProvider imageProvider;
  final VoidCallback onPickImage;

  /// بدلاً من isLoading فقط
  final ViewState state;
  final String? error;

  const ProfileHeader({
    super.key,
    required this.userInfo,
    required this.userImage,
    required this.pickedImage,
    required this.imageProvider,
    required this.onPickImage,
    required this.state,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      children: [
        UserImageWidget(
          image: pickedImage,
          imageBytes: userImage,
          imageLoading: imageProvider.loading,
          imageIsUploading: imageProvider.isUploading,
          onEdit: onPickImage,
        ),
        const SizedBox(height: 16),

        StateHandlerWidget(
          state: state,
          error: error,
          loadingBuilder: (context) => _skeletonLoading(theme),
          errorBuilder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "حدث خطأ أثناء تحميل البيانات: ${error ?? ''}",
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
          ),
          dataBuilder: (context) => _buildUserInfo(theme),
          emptyTitle: '',
          emptySubtitle: '',
        ),
      ],
    );
  }

  Widget _buildUserInfo(ThemeData theme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey("${userInfo?.givenName ?? ''} ${userInfo?.surname ?? ''}"),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserText(
            textStr: "${userInfo?.givenName ?? "-"} ${userInfo?.surname ?? "-"}",
            textStyle: theme.textTheme.displayLarge!,
          ),
          UserText(
            textStr: userInfo?.jobTitle ?? "-",
            textStyle: theme.textTheme.displayMedium!,
          ),
          UserText(
            textStr: userInfo?.mail ?? "-",
            textStyle: theme.textTheme.displaySmall!,
          ),
        ],
      ),
    );
  }

  Widget _skeletonLoading(ThemeData theme) {
    Widget skeletonBox(double width, double height) {
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

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surface,
      highlightColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          skeletonBox(200, 18),
          skeletonBox(150, 16),
          skeletonBox(100, 14),
        ],
      ),
    );
  }
}
