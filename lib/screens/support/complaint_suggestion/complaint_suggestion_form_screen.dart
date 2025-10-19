import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/support_forms_data.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/complaint_suggestion_provider.dart';
import '../../../../utils/app_notifier.dart';
import '../../../../utils/enums.dart';
import '../common_widgets/common_form_functions.dart';
import 'widgets/complaint_suggestion_option.dart';
import '../common_widgets/submit_button.dart';
import '../common_widgets/custom_drop_down_field_widget.dart';
import '../common_widgets/custom_text_field_widget.dart';

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
          widget.ensureUserId,
        );

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
  void dispose() {
    _issueTitleController.dispose();
    _issueDescriptionController.dispose();
    _nameController.dispose();
    super.dispose();
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                sendNameAsOptional(
                  theme, local,
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
                  (val) {
                    setState(() => selectedType = val);
                  },
                ),
                const SizedBox(height: 16),
                CustomDropDownFieldWidget(
                  value: selectedCategory,
                  label: local.category,
                  onChanged: (value) => setState(() => selectedCategory = value),
                  items: categories,
                  validator: (value) =>
                      CommonTextFieldForm.textFormFieldValidation(
                          value, local.pleaseSelectCategory),
                ),
                const SizedBox(height: 16),
                CustomDropDownFieldWidget(
                  value: selectedPriority,
                  label: local.priority,
                  onChanged: (value) => setState(() => selectedPriority = value),
                  items: priorities,
                  validator: (value) =>
                      CommonTextFieldForm.textFormFieldValidation(
                          value, local.pleaseSelectPriority),
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  controller: _issueTitleController,
                  label: local.issueTitle,
                  maxLines: 2,
                  validator:  (value) =>
                      CommonTextFieldForm.textFormFieldValidation(
                          value, local.pleaseEnterTitle),
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  controller: _issueDescriptionController,
                  label: local.issueDescription,
                  maxLines: 10,
                  validator:  (value) =>
                      CommonTextFieldForm.textFormFieldValidation(
                          value, local.pleaseEnterYourDescription),
                ),
                // DropdownButtonFormField2(
                //   value: selectedPriority,
                //   items: priorities.map((priority) {
                //     return DropdownMenuItem(
                //         value: priority['value'],
                //         child: Text(priority['label']!));
                //   }).toList(),
                //   decoration: CommonTextFieldForm.textFormFieldDecoration(
                //       local.priority, local),
                //   dropdownStyleData: CommonTextFieldForm.dropDownDecoration(),
                //   validator: (value) =>
                //       CommonTextFieldForm.textFormFieldValidation(
                //           value, local.pleaseSelectPriority),
                //   onChanged: (value) => setState(() => selectedPriority = value),
                // ),
                // DropdownButtonFormField2(
                //   value: selectedCategory,
                //   isExpanded: true,
                //   items: categories.map((category) {
                //     return DropdownMenuItem(
                //         value: category['value'],
                //         child: Text(category['label']!));
                //   }).toList(),
                //   decoration: CommonTextFieldForm.textFormFieldDecoration(
                //       local.category, local),
                //   dropdownStyleData: CommonTextFieldForm.dropDownDecoration(),
                //   validator: (value) =>
                //       CommonTextFieldForm.textFormFieldValidation(
                //           value, local.pleaseSelectCategory),
                //   onChanged: (value) => setState(() => selectedCategory = value),
                // ),
                // TextFormField(
                //   controller: _issueTitleController,
                //   decoration: CommonTextFieldForm.textFormFieldDecoration(
                //       local.issueTitle, local),
                //   maxLines: 2,
                //   validator: (value) =>
                //       CommonTextFieldForm.textFormFieldValidation(
                //           value, local.pleaseEnterTitle),
                // ),

                // TextFormField(
                //   controller: _issueDescriptionController,
                //   decoration: CommonTextFieldForm.textFormFieldDecoration(
                //       local.issueDescription, local),
                //   maxLines: 10,
                //   validator: (value) =>
                //       CommonTextFieldForm.textFormFieldValidation(
                //           value, local.pleaseEnterYourDescription),
                // ),
                const SizedBox(height: 16),
                SubmitButton(
                  btnText: local.submit,
                  btnFunction: () => _submitForm(local, complaintSuggestionProvider),
                ),
              ],
            ),
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
          decoration: CommonTextFieldForm.textFormFieldDecoration(
              local.nameOptional, local),
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
