import 'package:company_portal/utils/context_extensions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_notifier.dart';
import '../../../utils/enums.dart';

class ComplainSuggestionFormScreen extends StatefulWidget {
  const ComplainSuggestionFormScreen({super.key});

  @override
  State<ComplainSuggestionFormScreen> createState() =>
      _ComplainSuggestionFormScreenState();
}

class _ComplainSuggestionFormScreenState
    extends State<ComplainSuggestionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _complainOrSuggestionController =
      TextEditingController();

  String? _selectedCategory, _selectedPriority;

  final List<String> _categories = [
    'IT',
    'Marketing',
    'Customer Service',
    'HR',
    'Sales',
    'Finance'
  ];
  final List<String> _priorities = ['Low', 'Normal', 'High', 'Critical'];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      AppNotifier.snackBar(
          context, 'Form submitted successfully!', SnackBarType.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField2(
                value: _selectedCategory,
                isExpanded: true,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                      value: category, child: Text(category));
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                    isOverButton: false,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    )
                ),
                validator: (value) => value == null ? 'Please select a category' : null,
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField2(
                value: _selectedPriority,
                items: _priorities.map((priority) {
                  return DropdownMenuItem(
                      value: priority, child: Text(priority));
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Priority *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  isOverButton: false,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  )
                ),
                validator: (value) => value == null ? 'Please select a priority' : null,
                onChanged: (value) => setState(() => _selectedPriority = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _complainOrSuggestionController,
                decoration: const InputDecoration(
                  labelText: 'Complain / Suggestion *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                maxLines: 10,
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter your message' : null,
              ),
              const SizedBox( height: 24),
              _buildSubmitButton("Submit", theme, _submitForm),
            ],
          ),
        ),
      ),
    );
  }
}


Widget _buildSubmitButton(String btnText, ThemeData theme, void Function() btnFunction) {
  return ElevatedButton(
    onPressed: btnFunction,
    style: ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.secondary ,
      foregroundColor: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    child: Text(btnText, style: TextStyle(fontSize: 16, color: theme.colorScheme.background),),
  );
}
