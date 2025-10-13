import 'package:animations/animations.dart';
import 'package:company_portal/models/remote/new_user_request.dart';
import 'package:company_portal/providers/new_user_request_provider.dart';
import 'package:company_portal/screens/account/support/user_new_requests/user_new_request_form_screen.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewUserRequestHistory extends StatefulWidget {
  const NewUserRequestHistory({super.key});

  @override
  State<NewUserRequestHistory> createState() => _NewUserRequestHistoryState();
}

class _NewUserRequestHistoryState extends State<NewUserRequestHistory>
    with SingleTickerProviderStateMixin{

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
      context.read<NewUserRequestProvider>().getNewUserRequest();

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
    final newUserRequestProvider = context.watch<NewUserRequestProvider>();
    final newUserRequestList = newUserRequestProvider.newUserRequestList;
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: FadeTransition(
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
            return OpenContainer(
              closedElevation: 0,
              closedColor: Colors.transparent,
              openColor: theme.colorScheme.surface,
              transitionDuration: const Duration(milliseconds: 500),
              openBuilder: (context, _) => UserNewRequestFormScreen(userName: '', ensureUserId: 0, newUserRequest: item,),
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
                        item.enName ?? '',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          item.jobTitle ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.secondary,
                          ),
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
    )
    );
  }
}
