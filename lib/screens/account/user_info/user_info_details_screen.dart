import 'package:company_portal/screens/account/profile/profile_bloc/profile_bloc.dart';
import 'package:company_portal/screens/account/user_info/component/manager_info_widget.dart';
import 'package:company_portal/screens/account/user_info/component/personal_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:company_portal/utils/export_import.dart';
class UserInfoDetailsScreen extends StatelessWidget {
  final UserInfo userInfo;

  const UserInfoDetailsScreen({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.userInfo,
          backBtn: true,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (BuildContext context, state) {
            if(state.isLoading) return AppNotifier.loadingWidget(theme);
            if(state.errorMessage != null) return Center(child: Text("Error: ${state.errorMessage}"));
            if(state.managerInfo == null) return const Center(child: Text("No data exists"));
            return SideFadeSlideAnimation(
              delay: 0,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      PersonalInfoWidget(userInfo: userInfo),
                      const SizedBox(height: 10),
                      ManagerInfoWidget(managerInfo: state.managerInfo!),
                    ],
                  ),
                ),
              ),
            );
            }
        ),
      ),
    );
  }
}
