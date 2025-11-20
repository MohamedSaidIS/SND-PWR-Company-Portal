import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/export_import.dart';
import '../../common_widgets/attachment_widget.dart';

class ComplaintSuggestionForm extends StatefulWidget {
  final ComplaintSuggestionFormController controller;
  final int ensureUser;

  const ComplaintSuggestionForm(
      {required this.controller, required this.ensureUser, super.key});

  @override
  State<ComplaintSuggestionForm> createState() =>
      _ComplaintSuggestionFormState();
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
                  child: RadioButtonSelection(
                    text: local.complaint,
                    groupValue: widget.controller.selectedType!,
                    value: "Complaint",
                    onChange: (val) => widget.controller.selectedType = val,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RadioButtonSelection(
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
            // const AttachmentWidget(),
            // const SizedBox(height: 16),
            SubmitButton(
              btnText: local.submit,
              loading: widget.controller.isLoading,
              btnFunction: () async {
                setState(() => widget.controller.isLoading = true);
                await widget.controller
                    .submitForm(local, provider, widget.ensureUser);
                setState(() => widget.controller.isLoading = false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
