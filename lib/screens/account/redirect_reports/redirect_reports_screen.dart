import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class DirectReportsScreen extends StatefulWidget {
  const DirectReportsScreen({super.key});

  @override
  State<DirectReportsScreen> createState() => _DirectReportsScreenState();
}

class _DirectReportsScreenState extends State<DirectReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.directReport,
          backBtn: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Consumer<DirectReportsProvider>(
              builder: (context, provider,_){
                if (provider.loading) return AppNotifier.loadingWidget(theme);
                if (provider.error != null) return Text("${provider.error}");
                final reports =  provider.directReportList;
                if (reports!.isEmpty || reports == []) {
                  return NotFoundScreen(
                      image: "assets/images/no_team_member.png",
                      title: local.noTeamMembersAssigned,
                      subtitle: local.thereAreCurrentlyNoTeamMembersAssignedToYouForDisplay);
                }
                return _ListView(directReports: reports);
              })
        ),
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  final List<DirectReport> directReports;

  const _ListView({
    required this.directReports,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${local.yourTeamMembers}:",
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<DirectReportsProvider>().fetchRedirectReport();
            },
            child: ListView.separated(
              itemCount: directReports.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = directReports[index];
                return FutureBuilder(
                  future: Future.delayed(Duration(milliseconds: 100 * index)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const SizedBox.shrink();
                    }
                    return TweenAnimationBuilder<double>(
                      key: ValueKey(item.id ?? index),
                      duration: const Duration(milliseconds: 500),
                      tween: Tween(begin: 0, end: 1),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      ),
                      child: DirectReportCardWidget(directReportItem: item),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
