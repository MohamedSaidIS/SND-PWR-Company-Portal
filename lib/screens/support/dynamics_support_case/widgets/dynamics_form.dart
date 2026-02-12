import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/export_import.dart';

class DynamicsForm extends StatefulWidget {
  final int ensureUser;
  const DynamicsForm({required this.ensureUser,super.key});

  @override
  State<DynamicsForm> createState() => _DynamicsFormState();
}

class _DynamicsFormState extends State<DynamicsForm> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DynamicsProvider>();
    final controller = context.read<DynamicsFormController>();
    final local = context.local;

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextField(
                    controller: controller.title,
                    label: local.title,
                    validator: (v) => TextFieldHelper.optional(""),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextField(
                        key: const ValueKey('joiningDateField'),
                        controller: controller.date,
                        label: local.date,
                        readOnly: true,
                        validator: (v) =>
                            TextFieldHelper.textFormFieldValidation(
                                v, local.pleaseEnterDate),
                      )),
                      Align(
                        alignment: Alignment.topCenter,
                        child: IconButton(
                            onPressed: () {
                              controller.pickDate(context);
                            },
                            icon: const Icon(Icons.calendar_month_rounded)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.description,
                    label: local.description,
                    maxLines: 3,
                    validator: (val) => TextFieldHelper.textFormFieldValidation(
                        val, local.pleaseEnterYourDescription),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.area,
                    label: local.area,
                    validator: (val) => TextFieldHelper.textFormFieldValidation(
                        val, local.enterArea),
                  ),
                  const SizedBox(height: 16),
                  CustomDropDownField(
                    value: controller.selectedPriority,
                    label: local.priority,
                    onChanged: (val) => controller.selectedPriority = val,
                    validator: (val) => TextFieldHelper.textFormFieldValidation(
                        val, local.pleaseSelectPriority),
                    items: getPriorities(local),
                  ),
                  const SizedBox(height: 16),
                  CustomDropDownField(
                    value: controller.selectedPurpose,
                    label: local.purpose,
                    onChanged: (val) => controller.selectedPurpose = val,
                    validator: (val) => TextFieldHelper.textFormFieldValidation(
                        val, local.pleaseSelectPurpose),
                    items: getPurpose(local),
                  ),
                  const SizedBox(height: 16),
                  const AttachmentPicker(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SubmitButton(
            btnText: local.submit,
            loading: controller.isLoading,
            btnFunction: () async {
              setState(() => controller.isLoading = true);
              await controller.submitForm(
                  context, local, provider, widget.ensureUser);
              setState(() => controller.isLoading = false);
            },
          )
        ],
      ),
    );
  }
}
