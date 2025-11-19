import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool endIcon;
  final bool isNotification;
  final Color? textColor;
  final Widget Function()? navigatedPage;
  final Function()? logout;

  const MenuWidget(
      {super.key,
      required this.title,
      required this.icon,
      this.endIcon = true,
      this.isNotification = false,
      this.textColor,
      this.navigatedPage,
      this.logout});

  @override
  Widget build(BuildContext context) {
    final itemArrowIcon = context.itemArrowIcon;
    final theme = context.theme;

    return ListTile(
      onTap: endIcon
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return navigatedPage!();
                }),
              );
            }
          : logout,
      leading: buildNotification(isNotification, icon, textColor, theme),
      title: Text(
        title,
        style: theme.textTheme.displaySmall!.copyWith(color: textColor),
      ),
      trailing: endIcon
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
    );
  }
}

Widget buildNotification(
    bool isNotification, IconData icon, Color? textColor, ThemeData theme) {
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
                    child: const Text(
                      "10",
                      style: TextStyle(color: Colors.white, fontSize: 10),
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
