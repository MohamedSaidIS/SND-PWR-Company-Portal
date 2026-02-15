import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

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


  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ComplaintSuggestionForm(
          ensureUser: widget.ensureUserId,
          userName: widget.userName,
        ),
      ),
    );
  }
}

