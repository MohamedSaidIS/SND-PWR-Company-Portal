import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class DynamicsHistoryScreen extends StatefulWidget {
  final int ensureUserId;
  final dynamic userInfo;
  final Uint8List? userImage;

  const DynamicsHistoryScreen(
      {required this.ensureUserId,
      required this.userInfo,
      required this.userImage,
      super.key});

  @override
  State<DynamicsHistoryScreen> createState() => _DynamicsHistoryScreenState();
}

class _DynamicsHistoryScreenState extends State<DynamicsHistoryScreen>
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
      context.read<DynamicsProvider>().getDynamicsItems(widget.ensureUserId);

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
        "Dynamics History Screen", "Image: ${widget.userImage != null}");

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Consumer<DynamicsProvider>(
        builder: (context, provider, _) {
          if (provider.loading) return AppNotifier.loadingWidget(theme);

          final dynamicsItemsList = provider.dynamicsItemsList;
          return FadeTransition(
            opacity: _fadeAnimation,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeInOut,
              child: ListView.builder(
                key: ValueKey(dynamicsItemsList.length),
                padding: const EdgeInsets.all(10),
                itemCount: dynamicsItemsList.length,
                itemBuilder: (context, index) {
                  final item = dynamicsItemsList[index];
                  return HistoryTileWidget(
                    title: item.title ?? '',
                    id: item.id.toString(),
                    needStatus: true,
                    status: item.status ?? '',
                    navigatedScreen: HistoryItemDetails(
                      itemId: item.id.toString(),
                      title: item.title,
                      description: item.description,
                      status: item.status,
                      priority: item.priority,
                      createdDate: item.createdDate.toString(),
                      modifiedDate: item.modifiedDate.toString(),
                      app: null,
                      type: null,
                      area: item.area,
                      purpose: item.purpose,
                      userImage: widget.userImage,
                      userInfo: widget.userInfo,
                      commentCall: 'Dynamics',
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
