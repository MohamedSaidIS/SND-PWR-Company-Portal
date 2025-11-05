import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class UserInfoDetailsScreen extends StatefulWidget {
  const UserInfoDetailsScreen({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.userOfficeLocation,
  });

  final String userName, userPhone, userOfficeLocation;

  @override
  State<UserInfoDetailsScreen> createState() => _UserInfoDetailsScreenState();
}

class _UserInfoDetailsScreenState extends State<UserInfoDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            ? const Center(child: CircularProgressIndicator())
            : provider.error != null
            ? Center(
          child: Text("Error: ${provider.error}"),
        )
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    AnimatedCard(
                      delay: 0,
                      child: buildInfoCard([
                        buildSectionTitle(local.personalDetails, context, theme),
                        buildInfoRow(
                          local.name,
                          widget.userName,
                          LineAwesomeIcons.user,
                          theme,
                        ),
                        buildInfoRow(
                          local.phone,
                          widget.userPhone,
                          LineAwesomeIcons.phone_solid,
                          theme,
                        ),
                        buildInfoRow(
                          local.location,
                          widget.userOfficeLocation,
                          LineAwesomeIcons.map_pin_solid,
                          theme,
                        ),
                      ], theme),
                    ),
                    const SizedBox(height: 10),
                    AnimatedCard(
                      delay: 200,
                      child: buildInfoCard([
                        buildSectionTitle(
                            local.managerDetails, context, theme),
                        buildInfoRow(
                          local.name,
                          "${managerInfo?.givenName ?? "-"} ${managerInfo?.surname ?? "-"}",
                          LineAwesomeIcons.user,
                          theme,
                        ),
                        buildInfoRow(
                          local.jobTitle,
                          managerInfo?.jobTitle ?? "-",
                          Icons.work_outline,
                          theme,
                        ),
                        buildInfoRow(
                          local.email,
                          managerInfo?.mail ?? "-",
                          LineAwesomeIcons.mail_bulk_solid,
                          theme,
                        ),
                        buildInfoRow(
                          local.phone,
                          managerInfo?.mobilePhone ?? "-",
                          LineAwesomeIcons.phone_solid,
                          theme,
                        ),
                        buildInfoRow(
                          local.location,
                          managerInfo?.officeLocation ?? "-",
                          LineAwesomeIcons.map_pin_solid,
                          theme,
                        ),
                      ], theme),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget _buildBody(
//     BuildContext context,
//     DirectReportsProvider provider,
//     List<DirectReport>? directReports,
//     AppLocalizations local,
//     ThemeData theme,
//     ) {
//   if (provider.loading) {
//     return const _LoadingView();
//   }
//
//   if (provider.error != null) {
//     return _ErrorView(error: provider.error!);
//   }
//
//   return _ListView(directReports: directReports, local: local, theme: theme);
// }
// }

class AnimatedCard extends StatelessWidget {
  final Widget child;
  final int delay;

  const AnimatedCard({
    super.key,
    required this.child,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
      onEnd: () {},
    );
  }
}
