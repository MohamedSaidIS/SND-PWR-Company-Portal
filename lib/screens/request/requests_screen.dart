import 'package:company_portal/screens/request/widgets/request_card.dart';
import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final ValueNotifier<bool> isPressedNotifier = ValueNotifier(false);
  final ValueNotifier<Map<int, bool>> animatedCardsNotifier =
      ValueNotifier<Map<int, bool>>({});

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final items = getRequestItems(local);

    return Scaffold(
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
              return InkWell(
                splashColor: Colors.transparent,
                onTap: () async {
                  isPressedNotifier.value = true;
                  animatedCardsNotifier.value[index] = true;
                  await Future.delayed(const Duration(milliseconds: 70));
                  animatedCardsNotifier.value[index] = false;

                  navigationScreen(context, item.navigatedScreen);
                },
                child: ValueListenableBuilder<Map<int, bool>>(
                  valueListenable: animatedCardsNotifier,
                  builder: (context, animMap, _) {
                    final isAnimated = animMap[index] ?? false;
                    return RequestCard(item: item,isAnimated: isAnimated);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  void navigationScreen(BuildContext context, Widget navigatedScreen,) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return navigatedScreen;
        },
      ),
    );
  }
}
