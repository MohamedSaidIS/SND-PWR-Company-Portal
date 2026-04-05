import 'package:company_portal/screens/support/features/user_new_requests/bloc/new_user_bloc/new_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:company_portal/utils/export_import.dart';
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
      context.read<NewUserBloc>().add(GetNewUserItemsEvent(widget.ensureUserId));
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
    final local = context.local;

    return Scaffold(
      body: BlocBuilder<NewUserBloc, NewUserState>(
        builder: (BuildContext context, state) {
          switch(state){

            case NewUserLoading():
              return AppNotifier.loadingWidget(theme);
            case NewUserError():
              return Center(child: Row(children: [
                const Icon(Icons.error, color: Colors.red,),
                Text("Something went wrong ${state.errorMessage}", style: const TextStyle(color: Colors.red, fontSize: 16),)
              ]),);
            case NewUserEmpty():
              return NotFoundScreen(
                  image: "assets/images/no_request.png",
                  title: local.noItemsFound,
                  subtitle: local.thereIsNoDataToDisplay);
            case NewUserLoaded():
              return FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  child: ListView.builder(
                    key: ValueKey(state.newUserItems.length),
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 25),
                    itemCount: state.newUserItems.length,
                    itemBuilder: (context, index) {
                      final item = state.newUserItems[index];
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
          }
        },
      ),
    );
  }
}
