import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/export_import.dart';
import '../../common_widgets/attachment_widget.dart';

class ComplaintSuggestionForm extends StatefulWidget {
  final int ensureUser;
  final String userName;

  const ComplaintSuggestionForm(
      {required this.ensureUser, required this.userName, super.key});

  @override
  State<ComplaintSuggestionForm> createState() =>
      _ComplaintSuggestionFormState();
}

class _ComplaintSuggestionFormState extends State<ComplaintSuggestionForm> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<ComplaintSuggestionFormController>();
      controller.setUserName(widget.userName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ComplaintSuggestionProvider>();
    final controller = context.watch<ComplaintSuggestionFormController>();
    final local = context.local;

    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            SendOptionalName(
              isChecked: controller.isChecked,
              onChange: (val) => controller.isChecked = val!,
              nameController: controller.name,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RadioButtonSelection(
                    text: local.complaint,
                    groupValue: controller.selectedType!,
                    value: "Complaint",
                    onChange: (val) => controller.selectedType = val,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RadioButtonSelection(
                    text: local.suggestion,
                    groupValue: controller.selectedType!,
                    value: "Suggestion",
                    onChange: (val) => controller.selectedType = val,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomDropDownFieldWidget(
              value: controller.selectedCategory,
              label: local.category,
              onChanged: (val) => controller.selectedCategory = val,
              items: getCategories(local),
              validator: (val) => CommonTextFieldForm.textFormFieldValidation(
                  val, local.pleaseSelectCategory),
            ),
            const SizedBox(height: 16),
            CustomDropDownFieldWidget(
              value: controller.selectedPriority,
              label: local.priority,
              onChanged: (val) => controller.selectedPriority = val,
              items: getPriorities(local),
              validator: (val) => CommonTextFieldForm.textFormFieldValidation(
                  val, local.pleaseSelectPriority),
            ),
            const SizedBox(height: 16),
            CustomTextFieldWidget(
              controller: controller.issueTitle,
              label: local.issueTitle,
              maxLines: 2,
              validator: (value) => CommonTextFieldForm.textFormFieldValidation(
                  value, local.pleaseEnterTitle),
            ),
            const SizedBox(height: 16),
            CustomTextFieldWidget(
              controller: controller.issueDescription,
              label: local.issueDescription,
              maxLines: 4,
              validator: (value) => CommonTextFieldForm.textFormFieldValidation(
                  value, local.pleaseEnterYourDescription),
            ),
            const SizedBox(height: 16),
            const AttachmentWidget(),
            const SizedBox(height: 16),
            SubmitButton(
              btnText: local.submit,
              loading: controller.isLoading,
              btnFunction: () async {
                setState(() => controller.isLoading = true);
                await controller
                    .submitForm(context, local, provider, widget.ensureUser);
                setState(() => controller.isLoading = false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
