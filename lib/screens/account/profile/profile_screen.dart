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

      if (!context.mounted) return;

      AppNotifier.snackBar(context, local.profilePhotoUpdated, SnackBarType.success);
    } else {

      AppNotifier.snackBar(context, local.uploadPhotoFailed, SnackBarType.error);
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
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 45),
                child: Column(
                  children: [
                    ProfileHeader(
                      userInfo: userInfo,
                      userImage: userImage,
                      pickedImage: _image,
                      imageProvider: userImageProvider,
                      onPickImage: _showImagePickerOptions,
                      isLoading: userInfoProvider.loading,
                    ),
                    AppSeparators.dividerSeparate(),
                    MenuSection(
                      userInfo: userInfo,
                      onLogout: _logout,
                      userImage: userImage,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
