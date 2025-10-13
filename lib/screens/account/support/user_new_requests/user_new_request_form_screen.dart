import 'package:company_portal/common/custom_app_bar.dart';
import 'package:company_portal/data/support_forms_data.dart';
import 'package:company_portal/models/remote/new_user_request.dart';
import 'package:company_portal/providers/user_info_provider.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../settings/complaint_suggestion/widgets/submit_button.dart';
import '../common_form_funcs.dart';

class UserNewRequestFormScreen extends StatefulWidget {
  final String userName;
  final int ensureUserId;
  final NewUserRequest? newUserRequest;

  const UserNewRequestFormScreen({
    required this.userName,
    required this.ensureUserId,
    required this.newUserRequest,
    super.key,
  });

  @override
  State<UserNewRequestFormScreen> createState() =>
      _UserNewRequestFormScreenState();
}

class _UserNewRequestFormScreenState extends State<UserNewRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _joiningDateController = TextEditingController();
  final TextEditingController _englishNameController = TextEditingController();
  final TextEditingController _arabicNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _directManagerController =
      TextEditingController();
  final TextEditingController _laptopNeedForApprovalController =
      TextEditingController();
  final TextEditingController _requestSpecialSpecsController =
      TextEditingController();
  final TextEditingController _specificSoftwareNeededController =
      TextEditingController();
  final TextEditingController _currentMailToUseController =
      TextEditingController();
  final TextEditingController _specifyNeedForNewMailController =
      TextEditingController();
  final TextEditingController _specifyRoleDynamicsController =
      TextEditingController();
  String? selectedDeviceType,
      selectedNewRequest,
      selectedUseDynamics,
      selectNeedPhone;

  Future<void> pickDate(bool isArabic) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _joiningDateController.text = isArabic
            ? DateFormat('dd-MM-yyyy', 'ar').format(newDate)
            : DateFormat('dd-MM-yyyy').format(newDate);
      });
    } else {
      setState(() {
        _joiningDateController.text = "select Date";
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userInfo = context.read<UserInfoProvider>().userInfo;
      _directManagerController.text = userInfo!.mail!;
      if (widget.newUserRequest != null && mounted) {
        fillForm(context);
      } else {
        _joiningDateController.text = "select Date";
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _joiningDateController.dispose();
    _englishNameController.dispose();
    _arabicNameController.dispose();
    _locationController.dispose();
    _jobTitleController.dispose();
    _mobileNumberController.dispose();
    _departmentController.dispose();
    _directManagerController.dispose();
    _laptopNeedForApprovalController.dispose();
    // _requestSpecialSpecsController.dispose();
    // _specificSoftwareNeededController.dispose();
    _currentMailToUseController.dispose();
    _specifyNeedForNewMailController.dispose();
    _specifyRoleDynamicsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final isArabic = context.isArabic();
    final deviceTypes = getDeviceType(local);
    final newEmailRequests = getIfNewEmailNeeded(local);
    final yesNoList = getYesNoList(local);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: widget.newUserRequest != null
          ? CustomAppBar(
              title: local.newUserRequestDetails,
              backBtn: true,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration:
                    CommonTextFieldForm.textFormFieldDecoration(local.title),
                maxLines: 1,
                validator: (value) =>
                    CommonTextFieldForm.textFormFieldValidation(
                        value, local.pleaseEnterTitle),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _joiningDateController,
                      decoration: CommonTextFieldForm.textFormFieldDecoration(
                          local.joiningDate),
                      readOnly: true,
                      validator: (value) =>
                          CommonTextFieldForm.textFormFieldValidation(
                              value, local.pleaseEnterJoiningDate),
                    ),
                  ),
                  IconButton(
                      onPressed: () => pickDate(isArabic),
                      icon: const Icon(Icons.calendar_month_rounded))
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.locationStr),
                maxLines: 1,
                validator: (value) =>
                    CommonTextFieldForm.textFormFieldValidation(
                        value, local.pleaseEnterLocation),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _englishNameController,
                decoration:
                    CommonTextFieldForm.textFormFieldDecoration(local.enName),
                maxLines: 1,
                validator: (value) =>
                    CommonTextFieldForm.textFormFieldValidation(
                        value, local.pleaseEnterEnName),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _arabicNameController,
                decoration:
                    CommonTextFieldForm.textFormFieldDecoration(local.arName),
                maxLines: 1,
                validator: (value) =>
                    CommonTextFieldForm.textFormFieldValidation(
                        value, local.pleaseEnterArName),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jobTitleController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.jobTitlesStr),
                maxLines: 1,
                validator: (value) =>
                    CommonTextFieldForm.textFormFieldValidation(
                        value, local.pleaseEnterJobTitle),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mobileNumberController,
                decoration:
                    CommonTextFieldForm.textFormFieldDecoration(local.phoneNo),
                maxLines: 1,
                validator: (value) =>
                    CommonTextFieldForm.textFormFieldValidation(
                        value, local.pleaseEnterPhoneNo),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.departmentName),
                maxLines: 1,
                validator: (value) =>
                    CommonTextFieldForm.textFormFieldValidation(
                        value, local.pleaseEnterDepartment),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _directManagerController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.directManager),
                maxLines: 1,
                readOnly: true,
                validator: (value) =>
                    CommonTextFieldForm.textFormFieldValidation(
                        value, local.pleaseEnterTitle),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField2(
                value: selectedDeviceType,
                isExpanded: true,
                items: deviceTypes.map((device) {
                  return DropdownMenuItem(
                      value: device['value'], child: Text(device['label']!));
                }).toList(),
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.deviceRequestedType),
                dropdownStyleData: CommonTextFieldForm.dropDownDecoration(),
                validator: (value) =>
                    CommonTextFieldForm.textFormFieldValidation(
                        value, local.pleaseEnterDeviceType),
                onChanged: (value) =>
                    setState(() => selectedDeviceType = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _laptopNeedForApprovalController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.laptopBusinessNeedForApproval),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField2(
                value: selectedNewRequest,
                isExpanded: true,
                items: newEmailRequests.map((newEmail) {
                  return DropdownMenuItem(
                      value: newEmail['value'],
                      child: Text(newEmail['label']!));
                }).toList(),
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.newEmailRequested),
                dropdownStyleData: CommonTextFieldForm.dropDownDecoration(),
                validator: (value) =>
                    CommonTextFieldForm.textFormFieldValidation(
                        value, local.pleaseEnterNeedNewEMail),
                onChanged: (value) =>
                    setState(() => selectedNewRequest = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentMailToUseController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.currentEmailToUse),
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specifyNeedForNewMailController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.specifyTheBusinessNeedForNewEmail),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField2(
                value: selectedUseDynamics,
                isExpanded: true,
                items: yesNoList.map((item) {
                  return DropdownMenuItem(
                      value: item['value'], child: Text(item['label']!));
                }).toList(),
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.requestPhoneLine),
                dropdownStyleData: CommonTextFieldForm.dropDownDecoration(),
                validator: (value) =>
                    CommonTextFieldForm.textFormFieldValidation(
                        value, local.pleaseEnterNeedNewEMail),
                onChanged: (value) =>
                    setState(() => selectedNewRequest = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField2(
                value: selectNeedPhone,
                isExpanded: true,
                items: yesNoList.map((item) {
                  return DropdownMenuItem(
                      value: item['value'], child: Text(item['label']!));
                }).toList(),
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.requestAnAccountForMSDynamics),
                dropdownStyleData: CommonTextFieldForm.dropDownDecoration(),
                validator: (value) =>
                    CommonTextFieldForm.textFormFieldValidation(
                        value, local.pleaseEnterNeedNewEMail),
                onChanged: (value) =>
                    setState(() => selectedNewRequest = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specifyRoleDynamicsController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.specifyTheRoleMSDynamices),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _requestSpecialSpecsController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.requestSpecialSpecsForApproval),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specificSoftwareNeededController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(
                    local.specificSoftwareNeeded),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              SubmitButton(
                btnText:
                    widget.newUserRequest != null ? local.update : local.submit,
                btnFunction: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fillForm(BuildContext context) {
    final isArabic = context.isArabic();
    _titleController.text = widget.newUserRequest!.title!;
    _joiningDateController.text = isArabic
        ? DateFormat('dd-MM-yyyy', 'ar')
            .format(widget.newUserRequest!.joiningDate)
        : DateFormat('dd-MM-yyyy', 'en')
            .format(widget.newUserRequest!.joiningDate);
    _locationController.text = widget.newUserRequest!.location!;
    _englishNameController.text = widget.newUserRequest!.enName!;
    _arabicNameController.text = widget.newUserRequest!.arName!;
    _jobTitleController.text = widget.newUserRequest!.jobTitle!;
    _mobileNumberController.text = widget.newUserRequest!.phoneNo!;
    _departmentController.text = widget.newUserRequest!.department!;
    _laptopNeedForApprovalController.text =
        widget.newUserRequest!.laptopNeeds ?? "";
    _requestSpecialSpecsController.text =
        widget.newUserRequest!.specialSpecs ?? "";
    _specificSoftwareNeededController.text =
        widget.newUserRequest!.specificSoftware ?? "";
    _currentMailToUseController.text =
        widget.newUserRequest!.currentEmailToUse ?? "";
    _specifyNeedForNewMailController.text =
        widget.newUserRequest!.specifyNeedForNewEmail ?? "";
    _specifyRoleDynamicsController.text =
        widget.newUserRequest!.specifyDynamicsRole ?? "";
  }
}
