import 'dart:typed_data';

import 'package:company_portal/providers/e_commerce_provider.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/app_notifier.dart';
import '../../common_widgets/history_tile_widget.dart';
import '../../history_item_details_with_comments/screens/history_item_details.dart';

class EcommerceHistoryScreen extends StatefulWidget {
  final int ensureUserId;
  final dynamic userInfo;
  final Uint8List? userImage;

  const EcommerceHistoryScreen(
      {required this.ensureUserId,
      required this.userInfo,
      required this.userImage,
      super.key});

  @override
  State<EcommerceHistoryScreen> createState() => _EcommerceHistoryScreenState();
}

class _EcommerceHistoryScreenState extends State<EcommerceHistoryScreen>
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
      context.read<EcommerceProvider>().getEcommerceItems(widget.ensureUserId);

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
      body: Consumer<EcommerceProvider>(
        builder: (context, provider, _) {
          if (provider.loading) return AppNotifier.loadingWidget(theme);

          final ecommerceList = provider.ecommerceItemsList;
          return FadeTransition(
            opacity: _fadeAnimation,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeInOut,
              child: ListView.builder(
                key: ValueKey(ecommerceList.length),
                padding: const EdgeInsets.all(10),
                itemCount: ecommerceList.length,
                itemBuilder: (context, index) {
                  final item = ecommerceList[index];
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
                      app: item.app,
                      type: item.type,
                      userImage: widget.userImage,
                      userInfo: widget.userInfo,
                      commentCall: 'Alsanidi',
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
