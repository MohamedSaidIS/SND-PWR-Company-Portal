import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/export_import.dart';

class ComplaintSuggestionHistoryScreen extends StatefulWidget {
  final UserInfo userInfo;
  final Uint8List? userImage;
  final int ensureUserId;

  const ComplaintSuggestionHistoryScreen(
      {required this.userInfo, required this.userImage,required this.ensureUserId, super.key});

  @override
  State<ComplaintSuggestionHistoryScreen> createState() =>
      _ComplaintSuggestionHistoryScreenState();
}

class _ComplaintSuggestionHistoryScreenState
    extends State<ComplaintSuggestionHistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ComplaintSuggestionProvider>().getSuggestionsAndComplaints(widget.ensureUserId);
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    AppNotifier.logWithScreen(
        "History Screen", "Image: ${widget.userImage != null}");

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Consumer<ComplaintSuggestionProvider>(
        builder: (context, provider, _) {
          if (provider.loading) return AppNotifier.loadingWidget(theme);

          final complaintList = provider.complaintSuggestionList ?? [];
          return FadeTransition(
            opacity: _fadeAnimation,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              child: ListView.builder(
                key: ValueKey(complaintList.length),
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 25),
                itemCount: complaintList.length,
                itemBuilder: (context, index) {
                  final item = complaintList[index];
                  return TicketsHistory(
                    title: item.title ?? '',
                    id: item.id.toString(),
                    needStatus: true,
                    status: item.status ?? '',
                    navigatedScreen: TicketDetailsScreen(
                      itemId: item.id.toString(),
                      title: item.title,
                      description: item.description,
                      status: item.status,
                      priority: item.priority,
                      createdDate: item.createdDate.toString(),
                      modifiedDate: item.modifiedDate.toString(),
                      app: null,
                      type: null,
                      area: null,
                      purpose: null,
                      userImage: widget.userImage,
                      userInfo: widget.userInfo,
                      commentCall: 'It',
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
