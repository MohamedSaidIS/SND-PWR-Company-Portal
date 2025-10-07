
import 'dart:typed_data';
import 'package:company_portal/screens/account/support/complaint_suggestion/widgets/status_badge.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../providers/complaint_suggestion_provider.dart';
import '../../../../utils/app_notifier.dart';
import 'history_item_details.dart';
import 'package:animations/animations.dart';

class HistoryScreen extends StatefulWidget {
  final dynamic userInfo;
  final Uint8List? userImage;

  const HistoryScreen({required this.userInfo, required this.userImage, super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final complaintSuggestionProvider = context.read<ComplaintSuggestionProvider>();
      await complaintSuggestionProvider.fetchSuggestionsAndComplaints(widget.userInfo.id);

      if (mounted) _controller.forward(); // start fade animation after load
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final complaintSuggestionProvider = context.watch<ComplaintSuggestionProvider>();
    // final complaintSuggestionList = complaintSuggestionProvider.complaintSuggestionList!.toList();

    final theme = context.theme;
    final local = context.local;

    AppNotifier.logWithScreen("History Screen","Image: ${widget.userImage != null}");

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Consumer<ComplaintSuggestionProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return _skeletonLoading(context);
          }

          final complaintList = provider.complaintSuggestionList ?? [];

          return FadeTransition(
            opacity: _fadeAnimation,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeInOut,
              child: ListView.builder(
                key: ValueKey(complaintList.length),
                padding: const EdgeInsets.all(10),
                itemCount: complaintList.length,
                itemBuilder: (context, index) {
                  final item = complaintList[index];
                  return OpenContainer(
                    closedElevation: 0,
                    closedColor: Colors.transparent,
                    openColor: theme.colorScheme.surface,
                    transitionDuration: const Duration(milliseconds: 500),
                    openBuilder: (context, _) => HistoryItemDetails(
                      item: item,
                      userImage: widget.userImage,
                      userInfo: widget.userInfo,
                    ),
                    closedBuilder: (context, openContainer) => InkWell(
                      onTap: openContainer,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              item.fields?.title ?? '',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                "${local.issueID}: ${item.id ?? ''}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ),
                            trailing: Transform.translate(
                              offset: const Offset(10, 0),
                              child: StatusBadge(
                                status: item.fields?.status ?? '',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _skeletonLoading(BuildContext context) {
  Widget skeletonBox(double height) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade400,
      ),
    );
  }

  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 15,
      itemBuilder: (context, index){
        return skeletonBox(100);
      },
    ),
  );
}

