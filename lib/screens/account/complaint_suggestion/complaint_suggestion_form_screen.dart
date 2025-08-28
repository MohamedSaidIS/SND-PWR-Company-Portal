import 'package:company_portal/screens/account/complaint_suggestion/widgets/complaint_suggestion_option.dart';
import 'package:company_portal/screens/account/complaint_suggestion/widgets/submit_button.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/complain_and_suggestion_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/complaint_suggestion_provider.dart';
import '../../../utils/app_notifier.dart';
import '../../../utils/enums.dart';

class ComplaintSuggestionFormScreen extends StatefulWidget {
  final String userName;

  const ComplaintSuggestionFormScreen({required this.userName, super.key});

  @override
  State<ComplaintSuggestionFormScreen> createState() =>
      _ComplaintSuggestionFormScreenState();
}

class _ComplaintSuggestionFormScreenState  extends State<ComplaintSuggestionFormScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _issueTitleController = TextEditingController();
  final TextEditingController _issueDescriptionController = TextEditingController();
  String? selectedType, selectedCategory, selectedPriority = 'Normal';
  bool isChecked = true;

  void _submitForm(AppLocalizations local,
      ComplaintSuggestionProvider complaintSuggestionProvider) async {
    if (_formKey.currentState!.validate()) {
      if (complaintSuggestionProvider.loading) {
        AppNotifier.snackBar(context, "Please Wait", SnackBarType.info);
        return;
      } else {
        var successSend =
            await complaintSuggestionProvider.sendSuggestionsAndComplaints(
          _issueTitleController.text,
          _issueDescriptionController.text,
          selectedPriority!,
          selectedCategory!,
          isChecked? _nameController.text.trim() : '',
        );

        if (successSend) {
          clearData();
          AppNotifier.snackBar(
              context, local.fromSubmittedSuccessfully, SnackBarType.success);
        } else {
          AppNotifier.snackBar(
              context, "SomeThing went wrong", SnackBarType.error);
        }
      }
    }
  }

  void clearData() {
    _issueTitleController.clear();
    _issueDescriptionController.clear();
    selectedCategory = null;
    selectedPriority = 'Normal';
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName.trim();
    selectedType = "Complaint";
  }

  @override
  Widget build(BuildContext context) {
    final complaintSuggestionProvider =
        context.read<ComplaintSuggestionProvider>();
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: local.nameOptional,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                      ),
                      enabled: false,
                      readOnly: true,
                    ),
                  ),
                  IntrinsicWidth(
                    child: CheckboxListTile(
                      activeColor: theme.colorScheme.secondary,
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                      checkColor: theme.colorScheme.background,
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      title:  Transform.translate(
                        offset: const Offset(-20, 0),
                        child: const Text("Show Name"),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ComplaintSuggestionOption(
                      text: local.complaint,
                      groupValue: selectedType!,
                      value: "Complaint",
                      onChange: (val) {
                        setState(() => selectedType = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ComplaintSuggestionOption(
                      text: local.suggestion,
                      groupValue: selectedType!,
                      value: "Suggestion",
                      onChange: (val) {
                        setState(() => selectedType = val);
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
                      value: category['value'],
                      child: Text(category['label']!));
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
                    )),
                validator: (value) =>
                    value == null ? local.pleaseSelectCategory : null,
                onChanged: (value) => setState(() => selectedCategory = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField2(
                value: selectedPriority,
                items: priorities.map((priority) {
                  return DropdownMenuItem(
                      value: priority['value'],
                      child: Text(priority['label']!));
                }).toList(),
                decoration: InputDecoration(
                  labelText: local.priority,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                    isOverButton: false,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    )),
                validator: (value) =>
                    value == null ? local.pleaseSelectPriority : null,
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
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? local.pleaseEnterTitle
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _issueDescriptionController,
                decoration: InputDecoration(
                  labelText: local.issueDescription,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                ),
                maxLines: 10,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? local.pleaseEnterYourDescription
                    : null,
              ),
              const SizedBox(height: 16),
              SubmitButton(
                  btnText: local.submit,
                  btnFunction: () =>
                      _submitForm(local, complaintSuggestionProvider)),
            ],
          ),
        ),
      ),
    );
  }
}
