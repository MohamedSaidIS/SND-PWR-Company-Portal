import 'package:company_portal/screens/support/complaint_suggestion/controllers/complaint_suggestion_form_controller.dart';
import 'package:company_portal/screens/support/complaint_suggestion/widgets/send_optional_name.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/support_forms_data.dart';
import '../../../../providers/complaint_suggestion_provider.dart';
import '../../common_widgets/common_form_functions.dart';
import '../../common_widgets/custom_drop_down_field_widget.dart';
import '../../common_widgets/custom_text_field_widget.dart';
import '../../common_widgets/submit_button.dart';
import 'complaint_suggestion_option.dart';

class ComplaintSuggestionForm extends StatefulWidget {
  final ComplaintSuggestionFormController controller;
  final int ensureUser;

  const ComplaintSuggestionForm(
      {required this.controller, required this.ensureUser, super.key});

  @override
  State<ComplaintSuggestionForm> createState() => _ComplaintSuggestionFormState();
}

class _ComplaintSuggestionFormState extends State<ComplaintSuggestionForm> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ComplaintSuggestionProvider>();
    final local = context.local;

    return Form(
      key: widget.controller.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            SendOptionalName(
              isChecked: widget.controller.isChecked,
              onChange: (val) => widget.controller.isChecked = val!,
              nameController: widget.controller.name,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ComplaintSuggestionOption(
                    text: local.complaint,
                    groupValue: widget.controller.selectedType!,
                    value: "Complaint",
                    onChange: (val) => widget.controller.selectedType = val,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ComplaintSuggestionOption(
                    text: local.suggestion,
                    groupValue: widget.controller.selectedType!,
                    value: "Suggestion",
                    onChange: (val) => widget.controller.selectedType = val,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomDropDownFieldWidget(
              value: widget.controller.selectedCategory,
              label: local.category,
              onChanged: (val) => widget.controller.selectedCategory = val,
              items: getCategories(local),
              validator: (val) => CommonTextFieldForm.textFormFieldValidation(
                  val, local.pleaseSelectCategory),
            ),
            const SizedBox(height: 16),
            CustomDropDownFieldWidget(
              value: widget.controller.selectedPriority,
              label: local.priority,
              onChanged: (val) => widget.controller.selectedPriority = val,
              items: getPriorities(local),
              validator: (val) => CommonTextFieldForm.textFormFieldValidation(
                  val, local.pleaseSelectPriority),
            ),
            const SizedBox(height: 16),
            CustomTextFieldWidget(
              controller: widget.controller.issueTitle,
              label: local.issueTitle,
              maxLines: 2,
              validator: (value) => CommonTextFieldForm.textFormFieldValidation(
                  value, local.pleaseEnterTitle),
            ),
            const SizedBox(height: 16),
            CustomTextFieldWidget(
              controller: widget.controller.issueDescription,
              label: local.issueDescription,
              maxLines: 4,
              validator: (value) => CommonTextFieldForm.textFormFieldValidation(
                  value, local.pleaseEnterYourDescription),
            ),
            const SizedBox(height: 16),
            SubmitButton(
              btnText: local.submit,
              loading: widget.controller.isLoading,
                btnFunction: () async {
                  setState(() => widget.controller.isLoading = true);
                 await widget.controller.submitForm(local, provider, widget.ensureUser);
                  setState(() => widget.controller.isLoading = false);
                },
            ),
          ],
        ),
      ),
    );
  }
}
