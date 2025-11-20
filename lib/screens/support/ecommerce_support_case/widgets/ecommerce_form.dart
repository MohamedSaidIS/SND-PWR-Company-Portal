import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';


class EcommerceForm extends StatefulWidget {
  final EcommerceFormController controller;
  final int ensureUser;

  const EcommerceForm(
      {required this.controller, required this.ensureUser, super.key});

  @override
  State<EcommerceForm> createState() => _EcommerceFormState();
}

class _EcommerceFormState extends State<EcommerceForm> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EcommerceProvider>();
    final local = context.local;

    return Form(
      key: widget.controller.formKey,
      autovalidateMode: AutovalidateMode.disabled,
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
            CustomTextFieldWidget(
              controller: widget.controller.description,
              label: local.description,
              maxLines: 3,
              validator: (v) => CommonTextFieldForm.optional(""),
            ),
            const SizedBox(height: 16),
            CustomDropDownFieldWidget(
              value: widget.controller.selectedPriority,
              label: local.priority,
              onChanged: (val) => widget.controller.selectedPriority = val,
              validator: (v) => CommonTextFieldForm.textFormFieldValidation(v, local.pleaseSelectPriority),
              items: getPriorities(local),
            ),
            const SizedBox(height: 16),
            CustomDropDownFieldWidget(
              value: widget.controller.selectedApp,
              label: local.app,
              onChanged: (val) => widget.controller.selectedApp = val,
              validator: (v) => CommonTextFieldForm.textFormFieldValidation(v, local.pleaseSelectApp),
              items: getAppList(local),
            ),
            const SizedBox(height: 16),
            CustomDropDownFieldWidget(
              value: widget.controller.selectedType,
              label: local.type,
              onChanged: (val) => widget.controller.selectedType = val,
              items: getTypeList(local),
            ),
            const SizedBox(height: 16),
            AttachmentWidget(pickFile: widget.controller.pickFile),
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
