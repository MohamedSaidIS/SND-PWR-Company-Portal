import 'package:company_portal/providers/e_commerce_provider.dart';
import 'package:company_portal/screens/support/ecommerce_support_case/controllers/ecommerce_form_controllor.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/support_forms_data.dart';
import '../../common_widgets/common_form_functions.dart';
import '../../common_widgets/custom_drop_down_field_widget.dart';
import '../../common_widgets/custom_text_field_widget.dart';
import '../../common_widgets/submit_button.dart';

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
              items: getPriorities(local),
            ),
            const SizedBox(height: 16),
            CustomDropDownFieldWidget(
              value: widget.controller.selectedApp,
              label: local.app,
              onChanged: (val) => widget.controller.selectedApp = val,
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
