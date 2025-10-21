import 'package:company_portal/screens/support/complaint_suggestion/controllers/complaint_suggestion_form_controller.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import '../widgets/complaint_suggestion_form.dart';

class ComplaintSuggestionFormScreen extends StatefulWidget {
  final String userName;
  final int ensureUserId;

  const ComplaintSuggestionFormScreen({
    required this.userName,
    required this.ensureUserId,
    super.key,
  });

  @override
  State<ComplaintSuggestionFormScreen> createState() =>
      _ComplaintSuggestionFormScreenState();
}

class _ComplaintSuggestionFormScreenState extends State<ComplaintSuggestionFormScreen> {
  late ComplaintSuggestionFormController controller;
  
  @override
  void initState() {
    super.initState();
     controller = ComplaintSuggestionFormController(context, userName: widget.userName);

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ComplaintSuggestionForm(
          controller: controller,
          ensureUser: widget.ensureUserId,
        ),
      ),
    );
  }
}

