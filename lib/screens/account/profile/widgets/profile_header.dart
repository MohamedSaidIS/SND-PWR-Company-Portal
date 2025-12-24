import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic userInfo;
  final Uint8List? userImage;
  final File? pickedImage;
  final UserImageProvider imageProvider;
  final VoidCallback onPickImage;

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
          loadingBuilder: (context) => const UserInfoLoading(),
          errorBuilder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "حدث خطأ أثناء تحميل البيانات",
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
          ),
          dataBuilder: (context) => UserInfoWidget(userInfo: userInfo),
          emptyTitle: '',
          emptySubtitle: '',
        ),
      ],
    );
  }

}
