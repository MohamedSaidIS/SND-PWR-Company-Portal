import 'dart:io';
import 'dart:typed_data';
import 'package:company_portal/screens/account/profile/widgets/user_text.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../providers/user_image_provider.dart';
import 'user_image_widget.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic userInfo;
  final Uint8List? userImage;
  final File? pickedImage;
  final UserImageProvider imageProvider;
  final VoidCallback onPickImage;
  final bool isLoading;

  const ProfileHeader({
    super.key,
    required this.userInfo,
    required this.userImage,
    required this.pickedImage,
    required this.imageProvider,
    required this.onPickImage,
    required this.isLoading,
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
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isLoading || userInfo == null
              ? _skeletonLoading()
              : Column(
            key: ValueKey("${userInfo.givenName} ${userInfo.surname}"),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserText(
                  textStr: "${userInfo?.givenName ?? "-"} ${userInfo?.surname ?? "-"}",
                  textStyle: theme.textTheme.displayLarge!),
              UserText(
                  textStr: userInfo?.jobTitle ?? "-",
                  textStyle: theme.textTheme.displayMedium!),
              UserText(
                  textStr: userInfo?.mail ?? "-",
                  textStyle: theme.textTheme.displaySmall!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _skeletonLoading() {
    Widget skeletonBox(double width, double height) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8), // smoother look
          ),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
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
