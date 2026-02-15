import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/export_import.dart';

class NewUserRequestHistory extends StatefulWidget {
  final int ensureUserId;

  const NewUserRequestHistory({required this.ensureUserId, super.key});

  @override
  State<NewUserRequestHistory> createState() => _NewUserRequestHistoryState();
}

class _NewUserRequestHistoryState extends State<NewUserRequestHistory>
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
      context
          .read<NewUserRequestProvider>()
          .getNewUserRequest(widget.ensureUserId);

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

    return Scaffold(
      body: Consumer<NewUserRequestProvider>(
        builder: (context, provider, _) {
          if (provider.loading) return AppNotifier.loadingWidget(theme);

          final newUserRequestList = provider.newUserRequestList;
          return FadeTransition(
            opacity: _fadeAnimation,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              child: ListView.builder(
                key: ValueKey(newUserRequestList.length),
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 25),
                itemCount: newUserRequestList.length,
                itemBuilder: (context, index) {
                  final item = newUserRequestList[index];
                  return TicketsHistory(
                    title: TextHelper.capitalizeWords(item.enName ?? ''),
                    id: item.id.toString(),
                    needStatus: false,
                    status: '',
                    navigatedScreen: UserNewRequestFormScreen(
                      userName: "",
                      ensureUserId: widget.ensureUserId,
                      newUserRequest: item,
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
