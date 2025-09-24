import 'dart:io';
import 'package:company_portal/providers/user_image_provider.dart';
import 'package:company_portal/providers/user_info_provider.dart';
import 'package:company_portal/screens/account/profile/widgets/error_state_widget.dart';
import 'package:company_portal/screens/account/profile/widgets/menu_section.dart';
import 'package:company_portal/screens/account/profile/widgets/profile_header.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:company_portal/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/custom_app_bar.dart';
import '../../../utils/app_separators.dart';
import '../../../utils/image_picker_handler.dart';
import '../../login/login_screen_new.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserInfoProvider>();
      final imageProvider = context.read<UserImageProvider>();

      userProvider.fetchUserInfo();
      imageProvider.fetchImage();
    });
  }

  void _handleImagePick(File pickedImage) async {
    setState(() => _image = pickedImage);

    final local = context.local;
    final imageProvider = context.read<UserImageProvider>();
    final uploadedSuccess = await imageProvider.uploadImage(pickedImage);

    if (uploadedSuccess) {
      await Future.delayed(const Duration(milliseconds: 800));
      await imageProvider.fetchImage();
      setState(() => _image = null);

      AppNotifier.snackBar(
          context, local.profilePhotoUpdated, SnackBarType.success);
    } else {
      AppNotifier.snackBar(
          context, local.uploadPhotoFailed, SnackBarType.error);
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
    final userImageProvider = Provider.of<UserImageProvider>(context);

    final userInfo = userInfoProvider.userInfo;
    final userImage = userImageProvider.imageBytes;
    final theme = context.theme;
    final local = context.local;


    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: CustomAppBar(
          title: local.profile,
          themeBtn: true,
        ),
        body: Builder(
          builder: (context) {
            // if (userInfoProvider.error != null) {
            //   return ErrorStateWidget(
            //     error: userInfoProvider.error!,
            //     onRetry: () => context.read<UserInfoProvider>().fetchUserInfo(),
            //   );
            // }
            if(userImageProvider.error != null && userInfoProvider.error == "401"){
              return ErrorStateWidget(
                  error: userImageProvider.error!,
                  onRetry: _logout,
              );
            }
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
