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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Form(
          key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

            ],
          ),
        )),
      ),
    );
  }
}
