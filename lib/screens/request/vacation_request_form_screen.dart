import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

import '../../../../utils/export_import.dart';

class VacationRequestFormScreen extends StatefulWidget {
  final String? personnelNumber;

  const VacationRequestFormScreen({super.key, required this.personnelNumber});

  @override
  State<VacationRequestFormScreen> createState() =>
      _VacationRequestFormScreenState();
}

class _VacationRequestFormScreenState extends State<VacationRequestFormScreen> {
  late final VacationRequestController controller;

  @override
  void initState() {
    super.initState();
    controller = VacationRequestController(widget.personnelNumber);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final alignment = context.alignment;
    final locale = context.currentLocale();
    return ChangeNotifierProvider(
      create: (_) => controller,
      child: Consumer<VacationRequestController>(
          builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: SafeArea(
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFieldWidget(
                      controller: controller.management,
                      label: local.managementName,
                      validator: (v) =>
                          CommonTextFieldForm.textFormFieldValidation(
                              v, local.requiredField),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFieldWidget(
                      controller: controller.department,
                      label: local.departmentName,
                      validator: (v) =>
                          CommonTextFieldForm.textFormFieldValidation(
                              v, local.requiredField),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFieldWidget(
                      controller: controller.code,
                      label: local.employeeCode,
                      readOnly: true,
                      validator: (v) =>
                          CommonTextFieldForm.textFormFieldValidation(
                              v, local.requiredField),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFieldWidget(
                      controller: controller.jobTitle,
                      label: local.jobTitle,
                      validator: (v) =>
                          CommonTextFieldForm.textFormFieldValidation(
                              v, local.requiredField),
                    ),
                    const SizedBox(height: 16),
                    CustomDropDownFieldWidget(
                      value: controller.vacationType,
                      label: local.app,
                      onChanged: (val) => controller.vacationType = val,
                      validator: (v) =>
                          CommonTextFieldForm.textFormFieldValidation(
                              v, local.requiredField),
                      items: getAppList(local),
                    ),
                    const SizedBox(height: 16),
                    buildVacationDates(
                        controller, theme, local, alignment, locale, context),
                    const SizedBox(height: 8),
                    Consumer<VacationRequestController>(
                        builder: (context, controller, _) {
                      return Text(
                        '${local.vacationDays}: ${controller.vacationDays}',
                        style: theme.textTheme.headlineSmall,
                      );
                    }),
                    const SizedBox(height: 16),
                    Text(local.signature, style: theme.textTheme.displayMedium),
                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      child: Signature(
                        controller: controller.signatureController,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SubmitButton(
                      btnText: local.submit,
                      loading: controller.isLoading,
                      btnFunction: () async {
                        setState(() => controller.isLoading = true);
                        controller.submitRequest(context, local);
                        setState(() => controller.isLoading = false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
