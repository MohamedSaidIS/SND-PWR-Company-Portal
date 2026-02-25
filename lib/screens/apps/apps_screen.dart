import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';
import 'components/app_card.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final isTablet = context.isTablet();

    return Scaffold(
      appBar: CustomAppBar(
        title: local.apps,
        backBtn: false,
      ),
      body: UpFadeSlideAnimation(
        delay: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            itemCount: getAppItems.length,
            padding: const EdgeInsets.only(bottom: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 3 : 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final item = getAppItems[index];
              return AppCard(item: item,);
            },
          ),
        ),
      ),
    );
  }
}


