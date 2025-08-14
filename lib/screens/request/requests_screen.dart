import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../data/requests_data.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
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
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: theme.appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          title: Text(local.requests, style: theme.textTheme.headlineLarge),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
          child: GridView.builder(
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 3 : 2, // two columns
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildNewCard(
                item.icon,
                item.label,
                context,
                theme,
                item.navigatedScreen,
                isTablet,
                isLandScape,
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildNewCard(IconData icon, String label, BuildContext context,
    ThemeData theme, Widget navigatedScreen, bool isTablet, bool isLandScape) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: theme.colorScheme.primary.withOpacity(0.1),
    ),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return navigatedScreen;
            },
          ),
        );
      }, // add navigation
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: isTablet ? 90 : 60, color: theme.colorScheme.secondary),
            const SizedBox(height: 15),
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet && isLandScape ? 22 : 15,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ),
  );
}

