import 'package:flutter/material.dart';

class DynamicsScFormScreen extends StatefulWidget {
  final String userName;
  final int ensureUserId;

  const DynamicsScFormScreen({
    required this.userName,
    required this.ensureUserId,
    super.key,
  });

  @override
  State<DynamicsScFormScreen> createState() => _DynamicsScFormScreenState();
}

class _DynamicsScFormScreenState extends State<DynamicsScFormScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
