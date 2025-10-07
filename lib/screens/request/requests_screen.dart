import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import '../../common/custom_app_bar.dart';
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
              return _BuildNewCard(icon: item.icon, label: item.label, theme: theme, navigatedScreen: item.navigatedScreen);
              // return _buildNewCard(
              //   item.icon,
              //   item.label,
              //   context,
              //   theme,
              //   item.navigatedScreen,
              //   isTablet,
              //   isLandScape,
              // );
            },
          ),
        ),
      ),
    );
  }
}

class _BuildNewCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;
  final Widget navigatedScreen;

  const _BuildNewCard(
      {required this.icon,
      required this.label,
      required this.theme,
      required this.navigatedScreen,});

  @override
  State<_BuildNewCard> createState() => _BuildNewCardState();
}

class _BuildNewCardState extends State<_BuildNewCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isTablet = context.isTablet();
    final isLandScape = context.isLandScape();
    return AnimatedScale(
      duration: const Duration(milliseconds: 150),
      scale: _isPressed ? 0.98 : 1.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return widget.navigatedScreen;
              },
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon,
                    size: isTablet ? 90 : 60,
                    color: theme.colorScheme.secondary),
                const SizedBox(height: 15),
                Text(
                  widget.label,
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
      ),
    );
  }
}

// Widget _buildNewCard(IconData icon, String label, BuildContext context,
//     ThemeData theme, Widget navigatedScreen, bool isTablet, bool isLandScape) {
//   return InkWell(
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) {
//             return navigatedScreen;
//           },
//         ),
//       );
//     },
//     borderRadius: BorderRadius.circular(16),
//     child: Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: theme.colorScheme.primary.withValues(alpha: 0.1),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon,
//                 size: isTablet ? 90 : 60, color: theme.colorScheme.secondary),
//             const SizedBox(height: 15),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: isTablet && isLandScape ? 22 : 15,
//                 fontWeight: FontWeight.w600,
//                 color: theme.colorScheme.secondary,
//               ),
//               textAlign: TextAlign.center,
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }
