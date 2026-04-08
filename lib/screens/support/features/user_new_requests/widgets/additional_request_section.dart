import 'package:company_portal/screens/support/features/user_new_requests/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utils/export_import.dart';
import '../bloc/new_user_form_bloc/new_user_form_bloc.dart';

class AdditionalRequestSection extends StatelessWidget {
  final UserNewRequestFormController controller;

  const AdditionalRequestSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final local = context.local;

    return SectionCard(title: local.additionalRequests,
        children: [
          BlocSelector<NewUserFormBloc, NewUserFormState, String?>(
            selector: (state) => state.useDynamics,
            builder: (context, useDynamics) {
              return CustomDropDownField(
                key: const ValueKey('specifyTheRoleMSDynamics'),
                label: local.specifyTheRoleMSDynamics,
                value: useDynamics,
                items: getYesNoList(local),
                onChanged: (val) =>
                    context.read<NewUserFormBloc>().add(
                        ChangeUseDynamicsEvent(val!)),
                validator: (v) => TextFieldHelper.optional(""),
              );
            },
          ),
          CustomTextField(
            key: const ValueKey('specifyDynamics'),
            controller: controller.specifyDynamics,
            label: local.specifyTheRoleMSDynamics,
            maxLines: 3,
            validator: (v) => TextFieldHelper.optional(""),
          ),
          BlocSelector<NewUserFormBloc, NewUserFormState, String?>(
            selector: (state) =>state.needPhone,
            builder: (context, needPhone) {
              return CustomDropDownField(
                key: const ValueKey('requestPhoneLine'),
                label: local.requestPhoneLine,
                value: needPhone,
                items: getYesNoList(local),
                onChanged: (val) => context.read<NewUserFormBloc>().add(ChangeNeedPhoneEvent(val!)),
                validator: (v) => TextFieldHelper.optional(""),
              );
            },
          ),
          CustomTextField(
            key: const ValueKey('specialSpecs'),
            controller: controller.specialSpecs,
            label: local.requestSpecialSpecsForApproval,
            maxLines: 3,
            validator: (v) => TextFieldHelper.optional(""),
          ),
          CustomTextField(
            key: const ValueKey('specialSoftwareNeeded'),
            controller: controller.software,
            label: local.specificSoftwareNeeded,
            maxLines: 3,
            validator: (v) => TextFieldHelper.optional(""),
          ),
        ]
    );
  }
}
