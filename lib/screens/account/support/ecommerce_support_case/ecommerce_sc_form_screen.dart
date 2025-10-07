import 'package:flutter/material.dart';

class EcommerceScFormScreen extends StatefulWidget {
  final String userName;
  final int ensureUserId;

  const EcommerceScFormScreen({
    required this.userName,
    required this.ensureUserId,
    super.key,
  });

  @override
  State<EcommerceScFormScreen> createState() => _EcommerceScFormScreenState();
}

class _EcommerceScFormScreenState extends State<EcommerceScFormScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
