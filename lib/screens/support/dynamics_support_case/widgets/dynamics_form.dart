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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFieldWidget(
              controller: controller.title,
              label: local.title,
              validator: (v) => CommonTextFieldForm.optional(""),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: CustomTextFieldWidget(
                      key: const ValueKey('joiningDateField'),
                      controller: controller.date,
                      label: local.date,
                      readOnly: true,
                      validator: (v) => CommonTextFieldForm.textFormFieldValidation(
                          v, local.pleaseEnterDate),
                    )),
                Align(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                      onPressed: () {controller.pickDate(context);},
                      icon: const Icon(Icons.calendar_month_rounded)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextFieldWidget(
              controller: controller.description,
              label: local.description,
              maxLines: 3,
              validator: (val) => CommonTextFieldForm.textFormFieldValidation(val, local.pleaseEnterYourDescription),
            ),
            const SizedBox(height: 16),
            CustomTextFieldWidget(
              controller: controller.area,
              label: local.area,
              validator: (val) => CommonTextFieldForm.textFormFieldValidation(val, local.enterArea),
            ),
            const SizedBox(height: 16),
            CustomDropDownFieldWidget(
              value: controller.selectedPriority,
              label: local.priority,
              onChanged: (val) => controller.selectedPriority = val,
              validator: (val) => CommonTextFieldForm.textFormFieldValidation(val, local.pleaseSelectPriority),
              items: getPriorities(local),
            ),
            const SizedBox(height: 16),
            CustomDropDownFieldWidget(
              value: controller.selectedPurpose,
              label: local.purpose,
              onChanged: (val) => controller.selectedPurpose = val,
              validator: (val) => CommonTextFieldForm.textFormFieldValidation(val, local.pleaseSelectPurpose),
              items: getPurpose(local),
            ),
            const SizedBox(height: 16),
           const AttachmentWidget(),
            const SizedBox(height: 10),
            SubmitButton(
              btnText: local.submit,
              loading: controller.isLoading,
              btnFunction: () async {
                setState(() => controller.isLoading = true);
                await controller.submitForm(context, local, provider, widget.ensureUser);
                setState(() => controller.isLoading = false);
              },
            )
          ],
        ),
      ),
    );
  }
}
