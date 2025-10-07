import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class UserNewRequestFormScreen extends StatefulWidget {
  final String userName;
  final int ensureUserId;

  const UserNewRequestFormScreen({
    required this.userName,
    required this.ensureUserId,
    super.key,
  });

  @override
  State<UserNewRequestFormScreen> createState() =>
      _UserNewRequestFormScreenState();
}

class _UserNewRequestFormScreenState extends State<UserNewRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
