import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget(
      {super.key,
      required this.title,
      required this.icon,
      this.endIcon = true,
      this.textColor,
      this.navigatedPage,
      this.logout});

  final String title;
  final IconData icon;
  final bool endIcon;
  final Color? textColor;
  final Widget Function()? navigatedPage;
  final Function()? logout;

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
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: textColor != null
              ? textColor!.withOpacity(0.1)
              : theme.colorScheme.primary.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: textColor,
        ),
      ),
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
                color: theme.colorScheme.primary.withOpacity(0.1),
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
