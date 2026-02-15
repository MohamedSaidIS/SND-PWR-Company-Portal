import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
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
              return buildAppCard(
                buildCardInfo(
                  item.appIcon,
                  item.appName,
                  isTablet,
                ),
                item.packageName,
                item.iosAppId,
                context,
                theme,
                local,
              );
            },
          ),
        ),
      ),
    );
  }
}


