import 'package:company_portal/providers/new_user_request_provider.dart';
import 'package:company_portal/screens/support/user_new_requests/screens/user_new_request_form_screen.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/app_notifier.dart';
import '../../common_widgets/history_tile_widget.dart';

class NewUserRequestHistory extends StatefulWidget {
  final int ensureUserId;

  const NewUserRequestHistory({required this.ensureUserId, super.key});

  @override
  State<NewUserRequestHistory> createState() => _NewUserRequestHistoryState();
}

class _NewUserRequestHistoryState extends State<NewUserRequestHistory> with SingleTickerProviderStateMixin {
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
      context.read<NewUserRequestProvider>().getNewUserRequest(widget.ensureUserId);

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
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Consumer<NewUserRequestProvider>(
        builder: (context, provider, _) {
          if (provider.loading) return AppNotifier.loadingWidget(theme);

          final newUserRequestList = provider.newUserRequestList;
          return FadeTransition(
            opacity: _fadeAnimation,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeInOut,
              child: ListView.builder(
                key: ValueKey(newUserRequestList.length),
                padding: const EdgeInsets.all(10),
                itemCount: newUserRequestList.length,
                itemBuilder: (context, index) {
                  final item = newUserRequestList[index];
                  return HistoryTileWidget(
                    title: item.enName ?? '',
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
