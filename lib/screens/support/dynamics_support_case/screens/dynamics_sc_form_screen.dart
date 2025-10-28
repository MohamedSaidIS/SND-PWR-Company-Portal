import 'package:flutter/material.dart';
import 'package:company_portal/utils/export_import.dart';

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
  late final DynamicsFormController controller;

  @override
  void initState() {
    super.initState();
    controller = DynamicsFormController(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DynamicsForm(
            controller: controller,
            ensureUser: widget.ensureUserId,
          ),
        ),
      ),
    );
  }
}
