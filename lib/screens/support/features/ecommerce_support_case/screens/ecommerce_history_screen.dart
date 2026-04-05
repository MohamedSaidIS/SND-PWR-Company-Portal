import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:company_portal/utils/export_import.dart';
class EcommerceHistoryScreen extends StatefulWidget {
  final int ensureUserId;
  final dynamic userInfo;
  final Uint8List? userImage;

  const EcommerceHistoryScreen({required this.ensureUserId,
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
      context.read<ECommerceBloc>().add(GetECommerceItemsEvent(widget.ensureUserId));
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
        "Ecommerce History Screen", "Image: ${widget.userImage != null}");

    return Scaffold(
      body: BlocBuilder<ECommerceBloc, ECommerceState>(
        builder: (BuildContext context, ECommerceState state) {
          switch(state){
            case ECommerceLoading():
              return AppNotifier.loadingWidget(theme);
            case ECommerceError():
              return Center(child: Row(children: [
                const Icon(Icons.error, color: Colors.red,),
                Text("Something went wrong ${state.errorMessage}", style: const TextStyle(color: Colors.red, fontSize: 16),)
              ]),);
            case ECommerceEmpty():
              return NotFoundScreen(
                  image: "assets/images/no_request.png",
                  title: local.noItemsFound,
                  subtitle: local.thereIsNoDataToDisplay);
            case ECommerceLoaded():
            _controller.forward();
              return FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  child: ListView.builder(
                    key: ValueKey(state.ecommerceItems.length),
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 25),
                    itemCount: state.ecommerceItems.length,
                    itemBuilder: (context, index) {
                      final item = state.ecommerceItems[index];
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
                          app: item.app,
                          type: item.type,
                          area: null,
                          purpose: null,
                          userImage: widget.userImage,
                          userInfo: widget.userInfo,
                          commentCall: 'Alsanidi',
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
