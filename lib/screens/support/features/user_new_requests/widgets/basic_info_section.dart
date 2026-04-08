import 'package:company_portal/screens/support/features/user_new_requests/widgets/section_card.dart';
import 'package:flutter/material.dart';

import 'package:company_portal/utils/export_import.dart';

class BasicInfoSection extends StatelessWidget {
  final UserNewRequestFormController controller;
  const BasicInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    return SectionCard(title: local.basicInformation,
      children: [
        CustomTextField(
          key: const ValueKey('titleField'),
          controller: controller.title,
          label: local.title,
          validator: (v) => TextFieldHelper.textFormFieldValidation(
              v, local.pleaseEnterTitle),
        ),
        Row(
          children: [
            Expanded(
                child: CustomTextField(
                  key: const ValueKey('joiningDateField'),
                  controller: controller.joiningDate,
                  label: local.joiningDate,
                  readOnly: true,
                  validator: (v) => TextFieldHelper.textFormFieldValidation(
                      v, local.pleaseEnterJoiningDate),
                )),
            Align(
              alignment: Alignment.topCenter,
              child: IconButton(
                  onPressed: controller.pickDate,
                  icon: const Icon(Icons.calendar_month_rounded)),
            ),
          ],
        ),
        CustomTextField(
          key: const ValueKey('locationField'),
          controller: controller.location,
          label: local.locationStr,
          validator: (v) => TextFieldHelper.textFormFieldValidation(
              v, local.pleaseEnterLocation),
        ),
      ],
    );
  }
}
