import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;


  void _handleImagePick(File pickedImage) async {
    setState(() => _image = pickedImage);

    final local = context.local;
    final imageProvider = context.read<UserImageProvider>();
    final uploadedSuccess = await imageProvider.uploadImage(pickedImage);

    if (uploadedSuccess) {
      await Future.delayed(const Duration(milliseconds: 800));
      await imageProvider.fetchImage();
      setState(() => _image = null);

      if (mounted) AppNotifier.snackBar(context, local.profilePhotoUpdated, SnackBarType.success);
    } else {

      if (mounted) AppNotifier.snackBar(context, local.uploadPhotoFailed, SnackBarType.error);
    }
  }

  void _showImagePickerOptions() {
    ImagePickerHandler(context).showPicker(_handleImagePick);
  }

  void _logout() {
    AppNotifier.showLogoutDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = context.watch<UserInfoProvider>();
    final userImageProvider = context.watch<UserImageProvider>();

    final userInfo = userInfoProvider.userInfo;
    final userImage = userImageProvider.imageBytes;
    final theme = context.theme;
    final local = context.local;


    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.profile,
          themeBtn: true,
        ),
        body: SideFadeSlideAnimation(
          delay: 0,
          child: Builder(
            builder: (context) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 45),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: ProfileHeader(
                        userInfo: userInfo,
                        userImage: userImage,
                        pickedImage: _image,
                        imageProvider: userImageProvider,
                        onPickImage: _showImagePickerOptions,
                        state: userInfoProvider.state,
                        error: userInfoProvider.error,
                      ),
                    ),
                    SliverToBoxAdapter(child: AppSeparators.dividerSeparate()),
                    MenuSection(
                      userInfo: userInfo,
                      onLogout: _logout,
                      userImage: userImage,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
