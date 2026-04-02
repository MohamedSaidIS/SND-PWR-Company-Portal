import 'dart:typed_data';
import 'package:company_portal/screens/support/dynamics_support_case/bloc/dynamics_bloc/dynamics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      context.read<DynamicsBloc>().add(GetDynamicsItemsEvent(widget.ensureUserId));
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

    AppNotifier.logWithScreen(
        "Dynamics History Screen", "Image: ${widget.userImage != null}");

    return Scaffold(
      body: BlocBuilder<DynamicsBloc, DynamicsState>(
        builder: (BuildContext context, DynamicsState state) {
          switch(state){
            case DynamicsLoading():
              return AppNotifier.loadingWidget(theme);
            case DynamicsError():
              return Center(child: Row(children: [
                const Icon(Icons.error, color: Colors.red,),
                Text("Something went wrong ${state.errorMessage}", style: const TextStyle(color: Colors.red, fontSize: 16),)
              ]),);
            case DynamicsEmpty():
              return NotFoundScreen(
                  image: "assets/images/no_request.png",
                  title: local.noItemsFound,
                  subtitle: local.thereIsNoDataToDisplay);
            case DynamicsLoaded():
              _controller.forward();
              return FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  child: ListView.builder(
                    key: ValueKey(state.dynamicsList.length),
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 25),
                    itemCount: state.dynamicsList.length,
                    itemBuilder: (context, index) {
                      final item = state.dynamicsList[index];
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
          }
        },
      ),
    );
  }
}
