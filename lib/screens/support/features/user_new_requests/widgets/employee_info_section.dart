import 'package:company_portal/screens/support/features/user_new_requests/widgets/section_card.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/export_import.dart';

class EmployeeInfoSection extends StatelessWidget {
  final UserNewRequestFormController controller;
  const EmployeeInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    return SectionCard(
      title: local.employeeInformation,
        children: [
        CustomTextField(
          key: const ValueKey('englishName'),
          controller: controller.englishName,
          label: local.enName,
          validator: (v) => TextFieldHelper.textFormFieldValidation(
              v, local.pleaseEnterEnName),
        ),
        CustomTextField(
          key: const ValueKey('arabicName'),
          controller: controller.arabicName,
          label: local.arName,
          validator: (v) => TextFieldHelper.textFormFieldValidation(
              v, local.pleaseEnterArName),
        ),
        CustomTextField(
          key: const ValueKey('jobTitle'),
          controller: controller.jobTitle,
          label: local.jobTitlesStr,
          validator: (v) => TextFieldHelper.textFormFieldValidation(
              v, local.pleaseEnterJobTitle),
        ),
        CustomTextField(
          key: const ValueKey('mobile'),
          controller: controller.mobile,
          label: local.phoneNo,
          inputType: TextInputType.phone,
          validator: (v) => TextFieldHelper.textFormFieldValidation(
              v, local.pleaseEnterPhoneNo),
        ),
      ],
    );
  }
}
