import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

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
  late EcommerceFormController controller;

  @override
  void initState() {
    super.initState();
    controller = EcommerceFormController(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: EcommerceForm(
            controller: controller,
            ensureUser: widget.ensureUserId,
          ),
        ),
      ),
    );
  }
}
