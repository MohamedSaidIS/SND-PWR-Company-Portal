import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  bool isPressed = false;
  Map<int, bool> animatedCards = {};

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final isTablet = context.isTablet();
    final isLandScape = context.isLandScape();


    final items = getRequestItems(local);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.requests,
          backBtn: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
          child: UpFadeSlideAnimation(
            delay: 0,
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // two columns
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                final isAnimated = animatedCards[index] ?? false;
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () async {
                    setState(() {
                      isPressed = true;
                      animatedCards[index] = true;
                    });
                    await Future.delayed(
                        const Duration(milliseconds: 70));
                    setState(() {
                      animatedCards[index] = false;
                    });
                    navigationScreen(context, item.navigatedScreen);
                  },
                  child: buildRequestCard(theme, item, isAnimated, isTablet, isLandScape),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


