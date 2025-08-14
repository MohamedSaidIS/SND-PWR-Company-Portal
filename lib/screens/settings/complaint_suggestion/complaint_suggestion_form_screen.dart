
import 'package:company_portal/utils/context_extensions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../../data/complain_and_suggesstion_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_notifier.dart';
import '../../../utils/enums.dart';

class ComplaintSuggestionFormScreen extends StatefulWidget {
  final String userName;
  const ComplaintSuggestionFormScreen({required this.userName, super.key});

  @override
  State<ComplaintSuggestionFormScreen> createState() =>
      _ComplaintSuggestionFormScreenState();
}

class _ComplaintSuggestionFormScreenState extends State<ComplaintSuggestionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _issueTitleController = TextEditingController();
  final TextEditingController _issueDescriptionController = TextEditingController();
  String? selectedType, selectedCategory, selectedPriority = 'Normal' ;

  void _submitForm(AppLocalizations local) {
    if (_formKey.currentState!.validate()) {
      AppNotifier.snackBar(
          context, local.fromSubmittedSuccessfully, SnackBarType.success);
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName.trim();
    selectedType = "Complaint";
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final categories = getCategories(local);
    final priorities = getPriorities(local);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration:  InputDecoration(
                  labelText: local.nameOptional,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _complaintOrSuggestionOption(
                      local.complaint,
                      selectedType!,
                      "Complaint",
                      context,
                      theme,
                          (val) {
                        setState(() => selectedType = val);
                        print("SelectedType: $selectedType");
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _complaintOrSuggestionOption(
                      local.suggestion,
                      selectedType!,
                      "Suggestion",
                      context,
                      theme,
                          (val) {
                        setState(() => selectedType = val);
                        print("SelectedType: $selectedType");
                      },
                    ),
                  ),
                ],
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
                    borderRadius: BorderRadius.all(Radius.circular(7)),
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
                    borderRadius: BorderRadius.all(Radius.circular(7)),
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
                controller: _issueTitleController,
                decoration: InputDecoration(
                  labelText: local.issueTitle,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                ),
                maxLines: 2,
                validator: (value) => (value == null || value.trim().isEmpty) ? local.pleaseEnterTitle : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _issueDescriptionController,
                decoration:  InputDecoration(
                  labelText: local.issueDescription,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                ),
                maxLines: 10,
                validator: (value) => (value == null || value.trim().isEmpty) ? local.pleaseEnterYourDescription : null,
              ),
              const SizedBox( height: 16),
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
        borderRadius: BorderRadius.circular(7),
      ),
    ),
    child: Text(btnText, style: TextStyle(fontSize: 16, color: theme.colorScheme.background),),
  );
}

Widget _complaintOrSuggestionOption(
    String text,
    String groupValue,
    String value,
    BuildContext context,
    ThemeData theme,
    void Function(String?) onChanged,
    ) {
  return ListTile(
    onTap: () => onChanged(value),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    tileColor: groupValue == value
        ? theme.colorScheme.secondary.withOpacity(0.1)
        : theme.colorScheme.primary.withOpacity(0.1),
    leading: Radio<String>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: theme.colorScheme.secondary,
    ),
    title: Text(
      text,
      style: const TextStyle(fontSize: 13),
    ),
  );
}
