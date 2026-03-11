import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final Widget Function()? navigatedPage;
  final Color? textColor;
  final bool endIcon;
  final bool isNotification;
  final Function()? logout;
  final bool addSeparator;


  MenuItem(
      {required this.title,
        required this.icon,
        this.navigatedPage,
        this.textColor,
        this.endIcon = true,
        this.isNotification = false,
        this.logout,
        this.addSeparator = false
      });
}