import 'package:flutter/material.dart';

class RequestItem {
  final IconData icon;
  final String label;
  final Widget navigatedScreen;

  const RequestItem({
    required this.icon,
    required this.label,
    required this.navigatedScreen,
  });
}