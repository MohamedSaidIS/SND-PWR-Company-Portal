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
    final provider = context.watch<DirectReportsProvider>();
    final directReports = provider.directReportList;
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: StateHandlerWidget(
              state: provider.state,
              error: provider.error,
              emptyTitle: local.noTeamMembersAssigned,
              emptySubtitle:
                  local.thereAreCurrentlyNoTeamMembersAssignedToYouForDisplay,
              dataBuilder: (_) => _ListView(
                directReports: directReports!,
                local: local,
                theme: theme,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  final List<DirectReport> directReports;
  final AppLocalizations local;
  final ThemeData theme;

  const _ListView({
    required this.directReports,
    required this.local,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
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
