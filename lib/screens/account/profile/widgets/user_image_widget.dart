import 'dart:io';
import 'dart:typed_data';

import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class UserImageWidget extends StatelessWidget {
  final File? image;
  final Uint8List? imageBytes;
  final bool imageLoading;
  final bool imageIsUploading;
  final VoidCallback onEdit;

  const UserImageWidget({
    super.key,
    required this.image,
    required this.imageBytes,
    required this.imageLoading,
    required this.imageIsUploading,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return imageLoading
        ? _skeletonLoading()
        : Stack(
            children: [
              Container(
                width: 145,
                height: 145,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    120,
                  ),
                  color: theme.colorScheme.secondary,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(5, 5),
                      blurRadius: 5,
                      spreadRadius: 1,
                      color: Color(0x4C606060),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _buildImageContent(),
                      // child:!imageIsUploading && imageLoading
                      //     ? const CircularProgressIndicator()
                      //     :image != null
                      //     ? Image.file(
                      //         image!,
                      //         width: 200,
                      //         height: 200,
                      //         fit: BoxFit.cover,
                      //       )
                      //     : imageLoading
                      //         ? const Center(child: CircularProgressIndicator())
                      //         : imageBytes != null
                      //             ? Image.memory(
                      //                 imageBytes!,
                      //                 width: 200,
                      //                 height: 200,
                      //                 fit: BoxFit.cover,
                      //               )
                      //             : const Image(
                      //                 image: AssetImage(
                      //                     "assets/images/profile_avatar.png"),
                      //               ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 7,
                right: 7,
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17.5),
                      color: theme.colorScheme.secondaryContainer,
                    ),
                    child: Icon(
                      LineAwesomeIcons.pencil_alt_solid,
                      color: theme.colorScheme.background,
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  Widget _buildImageContent() {
    return !imageIsUploading && imageLoading
        ? const Center(child: CircularProgressIndicator())
        : image != null
            ? Image.file(image!, width: 200, height: 200, fit: BoxFit.cover)
            : imageBytes != null
                ? Image.memory(imageBytes!,
                    width: 200, height: 200, fit: BoxFit.cover)
                : const Image(
                    image: AssetImage("assets/images/profile_avatar.png"),
                  );
  }

  Widget _skeletonLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SizedBox(
        width: 145,
        height: 145,
        child: Stack(
          children: [
            // Skeleton for image circle
            Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
