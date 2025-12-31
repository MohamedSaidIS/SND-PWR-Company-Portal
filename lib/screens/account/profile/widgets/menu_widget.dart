import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  final MenuItem item;
  final int? badgeCount;

  const MenuWidget({super.key, required this.item, this.badgeCount});

  @override
  Widget build(BuildContext context) {
    final itemArrowIcon = context.itemArrowIcon;
    final theme = context.theme;

    return Column(
      children: [
        ListTile(
          onTap: item.endIcon
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return  item.navigatedPage!();
                    }),
                  );
                }
              :  item.logout,
          leading: buildNotification( item.isNotification,  item.icon,  item.textColor, theme, badgeCount),
          title: Text(
            item.title,
            style: theme.textTheme.displaySmall!.copyWith(color:  item.textColor),
          ),
          trailing:  item.endIcon
              ? Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    itemArrowIcon,
                    size: 18.0,
                    color: theme.colorScheme.primary,
                  ),
                )
              : null,
        ),
        item.addSeparator? AppSeparators.dividerSeparate(): const SizedBox.shrink(),
      ],
    );
  }
}

Widget buildNotification(
    bool isNotification, IconData icon, Color? textColor, ThemeData theme, int? badgeCount) {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: textColor != null
          ? textColor.withValues(alpha: 0.1)
          : theme.colorScheme.primary.withValues(alpha: 0.1),
    ),
    child: isNotification
        ? Stack(
            children: [
              IconButton(
                color: textColor,
                onPressed: () {},
                icon: Icon(icon),
              ),
              if (badgeCount != null && badgeCount > 0)
                Positioned(
                top: 8,
                left: 22,
                child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    constraints: const BoxConstraints(
                      minHeight: 18,
                      minWidth: 18,
                    ),
                    child: Text(
                    badgeCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    )),
              ),
            ],
          )
        : IconButton(
            onPressed: () {},
            icon: Icon(icon),
            color: textColor,
          ),
  );
}
