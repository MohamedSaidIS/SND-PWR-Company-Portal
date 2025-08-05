import 'dart:io';
import 'package:company_portal/providers/user_image_provider.dart';
import 'package:company_portal/providers/user_info_provider.dart';
import 'package:company_portal/screens/account/redirect_reports/redirect_reports_screen.dart';
import 'package:company_portal/screens/settings/settings_screen.dart';
import 'package:company_portal/screens/account/user_info/user_info_details_screen.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:company_portal/utils/enums.dart';
import 'package:company_portal/widgets/user_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_separators.dart';
import '../../../utils/image_picker_handler.dart';
import '../../../widgets/menu_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserInfoProvider>(context, listen: false);
      final imageProvider = Provider.of<UserImageProvider>(context, listen: false);

      provider.fetchUserInfo();
      imageProvider.fetchImage();
    });
  }

  void _handleImagePick(File pickedImage) async {
    setState(() => _image = pickedImage);

    final local = context.local;
    final imageProvider = Provider.of<UserImageProvider>(context, listen: false);
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
    final userInfoProvider = Provider.of<UserInfoProvider>(context);
    final userImageProvider = Provider.of<UserImageProvider>(context);
    final themeProvider = context.themeProvider;
    final userInfo = userInfoProvider.userInfo;
    final userImage = userImageProvider.imageBytes;
    final theme = context.theme;
    final local = context.local;
    final themeIcon = context.themeIcon;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: theme.appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          title: Text(local.profile, style: theme.textTheme.headlineLarge),
          actions: [
            IconButton(
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                icon: Icon(
                  themeIcon,
                  color: theme.colorScheme.primary,
                ))
          ],
        ),
        body: userInfoProvider.loading || userInfo == null
            ? const Center(child: CircularProgressIndicator())
            : userInfoProvider.error != null
                ? Center(child: Text("Error: ${userInfoProvider.error}"))
                : SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 45),
                      child: Column(
                        children: [
                           UserImageWidget(
                                  image: _image,
                                  imageBytes: userImage,
                                  imageLoading: userImageProvider.loading,
                                  imageIsUploading: userImageProvider.isUploading,
                                  onEdit: _showImagePickerOptions,
                                ),
                          const SizedBox(height: 8),
                          _buildUserText(
                              "${userInfo.givenName} ${userInfo.surname}",
                              theme.textTheme.displayLarge!),
                          _buildUserText(userInfo.jobTitle,
                              theme.textTheme.displayMedium!),
                          _buildUserText(
                              userInfo.mail, theme.textTheme.displaySmall!),
                          AppSeparators.dividerSeparate(),
                          MenuWidget(
                            title: local.userInformation,
                            icon: LineAwesomeIcons.user,
                            navigatedPage: () => UserInfoDetailsScreen(
                                userPhone: userInfo.mobilePhone,
                                userOfficeLocation: userInfo.officeLocation),
                            textColor: theme.colorScheme.primary,
                          ),
                          MenuWidget(
                            title: local.directReport,
                            icon: LineAwesomeIcons.book_solid,
                            navigatedPage: () => const DirectReportsScreen(),
                            textColor: theme.colorScheme.primary,
                          ),
                          AppSeparators.dividerSeparate(),
                          MenuWidget(
                            title: local.settings,
                            icon: LineAwesomeIcons.cog_solid,
                            navigatedPage: () => const SettingsScreen(),
                            textColor: theme.colorScheme.primary,
                          ),
                          MenuWidget(
                            title: local.logout,
                            icon: LineAwesomeIcons.sign_out_alt_solid,
                            endIcon: false,
                            textColor: theme.colorScheme.secondaryContainer,
                            logout: () => _logout(),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

Widget _buildUserText(String textStr, TextStyle textStyle) {
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
