import 'package:company_portal/screens/support/features/user_new_requests/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utils/export_import.dart';
import '../bloc/new_user_form_bloc/new_user_form_bloc.dart';

class DeviceEmailSection extends StatelessWidget {
  final UserNewRequestFormController controller;

  const DeviceEmailSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final local = context.local;

    return SectionCard(
      title: local.deviceAndEmailRequests,
      children: [
        BlocSelector<NewUserFormBloc, NewUserFormState, String?>(
          selector: (state) => state.deviceType,
          builder: (context, deviceType) {
            return CustomDropDownField(
              key: const ValueKey('deviceRequestedType'),
              label: local.deviceRequestedType,
              value: deviceType,
              items: getDeviceType(local),
              onChanged: (val) =>
                  context.read<NewUserFormBloc>().add(
                      ChangeDeviceTypeEvent(val!)),
              validator: (v) =>
                  TextFieldHelper.textFormFieldValidation(
                      v, local.pleaseEnterDeviceType),
            );
          },
        ),
        BlocSelector<NewUserFormBloc, NewUserFormState, String?>(
          selector: (state) => state.newEmail,
          builder: (context, newEmail) {
            return CustomDropDownField(
              key: const ValueKey('newEmailRequested'),
              label: local.newEmailRequested,
              value: newEmail,
              items: getYesNoList(local),
              onChanged: (val) => context.read<NewUserFormBloc>().add(ChangeNewEmailEvent(val!)),
              validator: (v) =>
                  TextFieldHelper.textFormFieldValidation(
                      v, local.pleaseEnterNeedNewEMail),
            );
          },
        ),
        CustomTextField(
          key: const ValueKey('currentMail'),
          controller: controller.currentMail,
          label: local.currentEmail,
          validator: (v) => TextFieldHelper.optional(""),
        ),
        CustomTextField(
          key: const ValueKey('specifyNewMail'),
          controller: controller.specifyNewMail,
          label: local.specifyTheBusinessNeedForNewEmail,
          maxLines: 3,
          validator: (v) => TextFieldHelper.optional(""),
        ),
      ],);
  }
}
