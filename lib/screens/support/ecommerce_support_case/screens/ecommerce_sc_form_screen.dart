import 'package:company_portal/screens/support/ecommerce_support_case/controllers/ecommerce_form_controllor.dart';
import 'package:company_portal/screens/support/ecommerce_support_case/widgets/ecommerce_form.dart';
import 'package:company_portal/utils/context_extensions.dart';
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
