import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';

Widget buildBasicInfoSection(AppLocalizations local, UserNewRequestFormController c, ThemeData theme) {
  return _buildCard(
    local.basicInformation,
    [
      CustomTextField(
        key: const ValueKey('titleField'),
        controller: c.title,
        label: local.title,
        validator: (v) => TextFieldHelper.textFormFieldValidation(
            v, local.pleaseEnterTitle),
      ),
      Row(
        children: [
          Expanded(
              child: CustomTextField(
                key: const ValueKey('joiningDateField'),
            controller: c.joiningDate,
            label: local.joiningDate,
            readOnly: true,
            validator: (v) => TextFieldHelper.textFormFieldValidation(
                v, local.pleaseEnterJoiningDate),
          )),
          Align(
            alignment: Alignment.topCenter,
            child: IconButton(
                onPressed: c.pickDate,
                icon: const Icon(Icons.calendar_month_rounded)),
          ),
        ],
      ),
      CustomTextField(
        key: const ValueKey('locationField'),
        controller: c.location,
        label: local.locationStr,
        validator: (v) => TextFieldHelper.textFormFieldValidation(
            v, local.pleaseEnterLocation),
      ),
    ], theme
  );
}

Widget buildEmployeeInfoSection(
    AppLocalizations local, UserNewRequestFormController c, ThemeData theme) {
  return _buildCard(local.employeeInformation, [
    CustomTextField(
      key: const ValueKey('englishName'),
      controller: c.englishName,
      label: local.enName,
      validator: (v) => TextFieldHelper.textFormFieldValidation(
          v, local.pleaseEnterEnName),
    ),
    CustomTextField(
      key: const ValueKey('arabicName'),
      controller: c.arabicName,
      label: local.arName,
      validator: (v) => TextFieldHelper.textFormFieldValidation(
          v, local.pleaseEnterArName),
    ),
    CustomTextField(
      key: const ValueKey('jobTitle'),
      controller: c.jobTitle,
      label: local.jobTitlesStr,
      validator: (v) => TextFieldHelper.textFormFieldValidation(
          v, local.pleaseEnterJobTitle),
    ),
    CustomTextField(
      key: const ValueKey('mobile'),
      controller: c.mobile,
      label: local.phoneNo,
      inputType: TextInputType.phone,
      validator: (v) => TextFieldHelper.textFormFieldValidation(
          v, local.pleaseEnterPhoneNo),
    ),

  ], theme);
}

Widget buildDeviceEmailSection(
    AppLocalizations local, UserNewRequestFormController c, ThemeData theme) {
  return _buildCard(local.deviceAndEmailRequests, [
    CustomDropDownField(
      key: const ValueKey('deviceRequestedType'),
      label: local.deviceRequestedType,
      value: c.deviceType,
      items: getDeviceType(local),
      onChanged: (v) => c.deviceType = v,
      validator: (v) => TextFieldHelper.textFormFieldValidation(
          v, local.pleaseEnterDeviceType),
    ),
    CustomDropDownField(
      key: const ValueKey('newEmailRequested'),
      label: local.newEmailRequested,
      value: c.newEmail,
      items: getYesNoList(local),
      onChanged: (v) => c.newEmail = v,
      validator: (v) => TextFieldHelper.textFormFieldValidation(
          v, local.pleaseEnterNeedNewEMail),
    ),
    CustomTextField(
      key: const ValueKey('currentMail'),
      controller: c.currentMail,
      label: local.currentEmail,
      validator: (v) => TextFieldHelper.optional(""),
    ),
    CustomTextField(
      key: const ValueKey('specifyNewMail'),
      controller: c.specifyNewMail,
      label: local.specifyTheBusinessNeedForNewEmail,
      maxLines: 3,
      validator: (v) => TextFieldHelper.optional(""),
    ),
  ], theme);
}

Widget buildAdditionalRequestsSection(
    AppLocalizations local, UserNewRequestFormController c, ThemeData theme) {
  return _buildCard(local.additionalRequests, [
    CustomDropDownField(
      key: const ValueKey('specifyTheRoleMSDynamics'),
      label: local.specifyTheRoleMSDynamics,
      value: c.useDynamics,
      items: getYesNoList(local),
      onChanged: (v) => c.useDynamics = v,
      validator: (v) => TextFieldHelper.optional(""),
    ),
    CustomTextField(
      key: const ValueKey('specifyDynamics'),
      controller: c.specifyDynamics,
      label: local.specifyTheRoleMSDynamics,
      maxLines: 3,
      validator: (v) => TextFieldHelper.optional(""),
    ),
    CustomDropDownField(
      key: const ValueKey('requestPhoneLine'),
      label: local.requestPhoneLine,
      value: c.needPhone,
      items: getYesNoList(local),
      onChanged: (v) => c.needPhone = v,
      validator: (v) => TextFieldHelper.optional(""),
    ),
    CustomTextField(
      key: const ValueKey('specialSpecs'),
      controller: c.specialSpecs,
      label: local.requestSpecialSpecsForApproval,
      maxLines: 3,
      validator: (v) => TextFieldHelper.optional(""),
    ),
    CustomTextField(
      key: const ValueKey('specialSoftwareNeeded'),
      controller: c.software,
      label: local.specificSoftwareNeeded,
      maxLines: 3,
      validator: (v) => TextFieldHelper.optional(""),
    ),
  ], theme);
}

Widget _buildCard(String title, List<Widget> children, ThemeData theme) {
  return Card(
    color: theme.colorScheme.surface,
    elevation: 5,
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.primary)),
            ),
          ...children.expand((w) => [w, const SizedBox(height: 10)]),
        ],
      ),
    ),
  );
}
