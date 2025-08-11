import 'package:company_portal/utils/context_extensions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_notifier.dart';
import '../../../utils/enums.dart';

class ComplainSuggestionFormScreen extends StatefulWidget {
  const ComplainSuggestionFormScreen({super.key});

  @override
  State<ComplainSuggestionFormScreen> createState() =>
      _ComplainSuggestionFormScreenState();
}

class _ComplainSuggestionFormScreenState extends State<ComplainSuggestionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _complainOrSuggestionController = TextEditingController();

  void _submitForm(AppLocalizations local) {
    if (_formKey.currentState!.validate()) {
      AppNotifier.snackBar(
          context, local.fromSubmittedSuccessfully, SnackBarType.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    String? selectedCategory, selectedPriority;

    final categories = [
      {'value': 'IT', 'label': local.it},
      {'value': 'Marketing', 'label': local.marketing},
      {'value': 'Customer Service', 'label': local.customerService},
      {'value': 'HR', 'label': local.hr},
      {'value': 'Sales', 'label': local.sales},
      {'value': 'Finance', 'label': local.finance},
    ];

    final priorities = [
      {'value': 'Low', 'label': local.low},
      {'value': 'Normal', 'label': local.normal},
      {'value': 'High', 'label': local.high},
      {'value': 'Critical', 'label': local.critical},
     ];

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
                decoration:  InputDecoration(
                  labelText: local.nameOptional,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField2(
                value: selectedCategory,
                isExpanded: true,
                items: categories.map((category) {
                  return DropdownMenuItem(
                      value: category['value'], child: Text(category['label']!));
                }).toList(),
                decoration: InputDecoration(
                  labelText: local.category,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                    isOverButton: false,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    )
                ),
                validator: (value) => value == null ? local.pleaseSelectCategory : null,
                onChanged: (value) => setState(() => selectedCategory = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField2(
                value: selectedPriority,
                items: priorities.map((priority) {
                  return DropdownMenuItem(
                      value: priority['value'], child: Text(priority['label']!));
                }).toList(),
                decoration:  InputDecoration(
                  labelText: local.priority,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  isOverButton: false,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  )
                ),
                validator: (value) => value == null ? local.pleaseSelectPriority : null,
                onChanged: (value) => setState(() => selectedPriority = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _complainOrSuggestionController,
                decoration:  InputDecoration(
                  labelText: local.complaintSuggestionField,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                maxLines: 10,
                validator: (value) => (value == null || value.trim().isEmpty) ? local.pleaseEnterYourMessage : null,
              ),
              const SizedBox( height: 24),
              _buildSubmitButton(local.submit, theme, () => _submitForm(local)),
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
