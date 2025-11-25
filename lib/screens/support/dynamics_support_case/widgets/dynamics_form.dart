import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class DynamicsForm extends StatefulWidget {
  final DynamicsFormController controller;
  final int ensureUser;
  const DynamicsForm({required this.controller,required this.ensureUser,super.key});

  @override
  State<DynamicsForm> createState() => _DynamicsFormState();
}

class _DynamicsFormState extends State<DynamicsForm> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DynamicsProvider>();
    final local = context.local;

    return Form(
      key: widget.controller.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFieldWidget(
              controller: widget.controller.title,
              label: local.title,
              validator: (v) => CommonTextFieldForm.optional(""),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: CustomTextFieldWidget(
                      key: const ValueKey('joiningDateField'),
                      controller: widget.controller.date,
                      label: local.date,
                      readOnly: true,
                      validator: (v) => CommonTextFieldForm.textFormFieldValidation(
                          v, local.pleaseEnterDate),
                    )),
                Align(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                      onPressed: widget.controller.pickDate,
                      icon: const Icon(Icons.calendar_month_rounded)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextFieldWidget(
              controller: widget.controller.description,
              label: local.description,
              maxLines: 3,
              validator: (val) => CommonTextFieldForm.textFormFieldValidation(val, local.pleaseEnterYourDescription),
            ),
            const SizedBox(height: 16),
            CustomTextFieldWidget(
              controller: widget.controller.area,
              label: local.area,
              validator: (val) => CommonTextFieldForm.textFormFieldValidation(val, local.enterArea),
            ),
            const SizedBox(height: 16),
            CustomDropDownFieldWidget(
              value: widget.controller.selectedPriority,
              label: local.priority,
              onChanged: (val) => widget.controller.selectedPriority = val,
              validator: (val) => CommonTextFieldForm.textFormFieldValidation(val, local.pleaseSelectPriority),
              items: getPriorities(local),
            ),
            const SizedBox(height: 16),
            CustomDropDownFieldWidget(
              value: widget.controller.selectedPurpose,
              label: local.purpose,
              onChanged: (val) => widget.controller.selectedPurpose = val,
              validator: (val) => CommonTextFieldForm.textFormFieldValidation(val, local.pleaseSelectPurpose),
              items: getPurpose(local),
            ),
            const SizedBox(height: 16),
           // AttachmentWidget(pickFile: widget.controller.pickFile, allAttachedFiles: []),
            const SizedBox(height: 10),
            SubmitButton(
              btnText: local.submit,
              loading: widget.controller.isLoading,
              btnFunction: () async {
                setState(() => widget.controller.isLoading = true);
                await widget.controller.submitForm(local, provider, widget.ensureUser);
                setState(() => widget.controller.isLoading = false);
              },
            )
          ],
        ),
      ),
    );
  }
}
