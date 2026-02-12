import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';


class EcommerceForm extends StatefulWidget {
  final int ensureUser;

  const EcommerceForm({required this.ensureUser, super.key});

  @override
  State<EcommerceForm> createState() => _EcommerceFormState();
}

class _EcommerceFormState extends State<EcommerceForm> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EcommerceProvider>();
    final controller = context.read<EcommerceFormController>();
    final local = context.local;

    return Form(
      key: controller.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                CustomTextField(
                  controller: controller.title,
                  label: local.title,
                  validator: (v) => TextFieldHelper.optional(""),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller.description,
                  label: local.description,
                  maxLines: 3,
                  validator: (v) => TextFieldHelper.optional(""),
                ),
                const SizedBox(height: 16),
                CustomDropDownField(
                  value: controller.selectedPriority,
                  label: local.priority,
                  onChanged: (val) => controller.selectedPriority = val,
                  validator: (v) => TextFieldHelper.textFormFieldValidation(v, local.pleaseSelectPriority),
                  items: getPriorities(local),
                ),
                const SizedBox(height: 16),
                CustomDropDownField(
                  value: controller.selectedApp,
                  label: local.app,
                  onChanged: (val) => controller.selectedApp = val,
                  validator: (v) => TextFieldHelper.textFormFieldValidation(v, local.pleaseSelectApp),
                  items: getAppList(local),
                ),
                const SizedBox(height: 16),
                CustomDropDownField(
                  value: controller.selectedType,
                  label: local.type,
                  onChanged: (val) => controller.selectedType = val,
                  items: getTypeList(local),
                ),
                const SizedBox(height: 16),
                const AttachmentPicker(),
                const SizedBox(height: 16),
              ],),
            ),
          ),
          const SizedBox(height: 10),
          SubmitButton(
            btnText: local.submit,
            loading: controller.isLoading,
            btnFunction: () async {
              setState(() => controller.isLoading = true);
              await controller.submitForm(context, local, provider, widget.ensureUser);
              setState(() => controller.isLoading = false);
            },
          ),
        ],
      ),
    );
  }
}
