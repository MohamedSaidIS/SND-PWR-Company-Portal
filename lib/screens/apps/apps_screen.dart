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

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.apps,
          backBtn: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
          child: GridView.builder(
            itemCount: getAppItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 3 : 2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
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


