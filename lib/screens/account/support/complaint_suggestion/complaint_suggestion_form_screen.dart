import 'package:company_portal/screens/account/support/common_form_funcs.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/support_forms_data.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/complaint_suggestion_provider.dart';
import '../../../../utils/app_notifier.dart';
import '../../../../utils/enums.dart';
import '../../../settings/complaint_suggestion/widgets/complaint_suggestion_option.dart';
import '../../../settings/complaint_suggestion/widgets/submit_button.dart';

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

class _ComplaintSuggestionFormScreenState
    extends State<ComplaintSuggestionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _issueTitleController = TextEditingController();
  final TextEditingController _issueDescriptionController =
      TextEditingController();
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
                isChecked ? _nameController.text.trim() : '',
                widget.ensureUserId);

        if (successSend) {
          clearData();
          AppNotifier.snackBar(
              context, local.fromSubmittedSuccessfully, SnackBarType.success);
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
        context.watch<ComplaintSuggestionProvider>();

    final theme = context.theme;
    final local = context.local;
    final categories = getCategories(local);
    final priorities = getPriorities(local);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              sendNameAsOptional(
                theme,
                local,
                isChecked,
                (value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
                _nameController,
              ),
              const SizedBox(height: 16),
              selectComplaintOrIssue(
                local,
                selectedType!,
                (val) {setState(() => selectedType = val);
                },
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
                decoration: CommonTextFieldForm.textFormFieldDecoration(local.category),
                dropdownStyleData: CommonTextFieldForm.dropDownDecoration(),
                validator: (value) => CommonTextFieldForm.textFormFieldValidation(value, local.pleaseSelectCategory),
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
                decoration: CommonTextFieldForm.textFormFieldDecoration(local.priority),
                dropdownStyleData: CommonTextFieldForm.dropDownDecoration(),
                validator: (value) => CommonTextFieldForm.textFormFieldValidation(value, local.pleaseSelectPriority),
                onChanged: (value) => setState(() => selectedPriority = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _issueTitleController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(local.issueTitle),
                maxLines: 2,
                validator: (value) => CommonTextFieldForm.textFormFieldValidation(value, local.pleaseEnterTitle),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _issueDescriptionController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(local.issueDescription),
                maxLines: 10,
                validator: (value) => CommonTextFieldForm.textFormFieldValidation(
                    value, local.pleaseEnterYourDescription),
              ),
              const SizedBox(height: 16),
              SubmitButton(
                btnText: local.submit,
                btnFunction: () =>
                    _submitForm(local, complaintSuggestionProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget selectComplaintOrIssue(
  AppLocalizations local,
  String selectedType,
  Null Function(dynamic val) onChangeFun,
) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: ComplaintSuggestionOption(
            text: local.complaint,
            groupValue: selectedType,
            value: "Complaint",
            onChange: onChangeFun),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: ComplaintSuggestionOption(
          text: local.suggestion,
          groupValue: selectedType,
          value: "Suggestion",
          onChange: onChangeFun,
        ),
      ),
    ],
  );
}

Widget sendNameAsOptional(
    ThemeData theme,
    AppLocalizations local,
    bool isChecked,
    Null Function(dynamic val) onChangeFun,
    TextEditingController nameController) {
  return Row(
    children: [
      Expanded(
        child: TextFormField(
          controller: nameController,
          decoration: CommonTextFieldForm.textFormFieldDecoration(local.nameOptional),
          enabled: false,
          readOnly: true,
        ),
      ),
      IntrinsicWidth(
        child: CheckboxListTile(
          activeColor: theme.colorScheme.secondary,
          value: isChecked,
          onChanged: onChangeFun,
          checkColor: theme.colorScheme.surface,
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Transform.translate(
            offset: const Offset(-20, 0),
            child: const Text("Show Name"),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      )
    ],
  );
}


