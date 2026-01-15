import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class UserInfoDetailsScreen extends StatelessWidget {
  final UserInfo userInfo;

  const UserInfoDetailsScreen({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ManagerInfoProvider>();
    final managerInfo = provider.managerInfo;
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
        body: provider.loading
            ? AppNotifier.loadingWidget(theme)
            : provider.error != null
                ? Center(
                    child: Text("Error: ${provider.error}"),
                  )
                : SideFadeSlideAnimation(
                    delay: 0,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            buildPersonalCard(local, userInfo),
                            const SizedBox(height: 10),
                            buildManagerCard(local, managerInfo!),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
