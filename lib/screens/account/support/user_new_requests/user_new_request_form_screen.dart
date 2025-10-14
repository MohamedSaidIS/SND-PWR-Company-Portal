import 'package:company_portal/common/custom_app_bar.dart';
import 'package:company_portal/data/support_forms_data.dart';
import 'package:company_portal/models/remote/new_user_request.dart';
import 'package:company_portal/providers/new_user_request_provider.dart';
import 'package:company_portal/providers/user_info_provider.dart';
import 'package:company_portal/screens/account/support/user_new_requests/custom_drop_down_field_widget.dart';
import 'package:company_portal/screens/account/support/user_new_requests/custom_textfield_widget.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../utils/app_notifier.dart';
import '../../../../utils/enums.dart';
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
  late final List<TextEditingController> _controllers;

  String? selectedDeviceType,
      selectedNewEmail,
      selectedUseDynamics,
      selectNeedPhone;
  bool _isLoading = false,  _isFilling = false;

  @override
  void initState() {
    super.initState();

    _controllers = [
      _titleController,
      _joiningDateController,
      _englishNameController,
      _arabicNameController,
      _locationController,
      _jobTitleController,
      _mobileNumberController,
      _departmentController,
      _directManagerController,
      _laptopNeedForApprovalController,
      _requestSpecialSpecsController,
      _specificSoftwareNeededController,
      _currentMailToUseController,
      _specifyNeedForNewMailController,
      _specifyRoleDynamicsController,
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userInfo = context.read<UserInfoProvider>().userInfo;
      _directManagerController.text = userInfo!.mail ?? "";
      if (widget.newUserRequest != null && mounted) {
        fillForm(context);
      }
    });
  }

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _joiningDateController.text =
            DateFormat('dd-MM-yyyy', context.currentLocale())
                .format(pickedDate);
      });
    }
    // else {
    //   setState(() {
    //     _joiningDateController.text = "select Date";
    //   });
    // }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitForm(AppLocalizations local,
      NewUserRequestProvider newUserRequestProvider) async {
    if (!_formKey.currentState!.validate()) {
      AppNotifier.snackBar(
          context, "Fill required fields", SnackBarType.warning);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final parsed =
          DateFormat('dd-MM-yyyy').parse(_joiningDateController.text);
      final formattedDate = parsed.toUtc().toIso8601String();
      print("Time $formattedDate");

      final successSend = await newUserRequestProvider.createNewUserRequest(
        _titleController.text,
        _departmentController.text,
        _englishNameController.text,
        _arabicNameController.text,
        _locationController.text,
        _jobTitleController.text,
        _mobileNumberController.text,
        _laptopNeedForApprovalController.text,
        _requestSpecialSpecsController.text,
        _specificSoftwareNeededController.text,
        _currentMailToUseController.text,
        _specifyNeedForNewMailController.text,
        _specifyRoleDynamicsController.text,
        widget.ensureUserId,
        formattedDate,
        selectedNewEmail!,
        selectNeedPhone ?? "",
        selectedUseDynamics ?? "",
        selectedDeviceType!,
      );

      if (successSend) {
        clearData();
        AppNotifier.snackBar(
            context, local.fromSubmittedSuccessfully, SnackBarType.success);
      }
    } catch (e) {
      print("Error in _submitForm: $e");
      AppNotifier.snackBar(context, "Something went wrong", SnackBarType.error);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void clearData() {
    for (var controller in _controllers) {
      if (controller != _directManagerController) {
        controller.clear();
      }
    }
    selectedNewEmail = null;
    selectNeedPhone = null;
    selectedUseDynamics = null;
    selectedDeviceType = null;
  }

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final theme = context.theme;
    final newUserRequestProvider = context.watch<NewUserRequestProvider>();
    final newEmailRequests = getIfNewEmailNeeded(local);
    final deviceTypes = getDeviceType(local);
    final yesNoList = getYesNoList(local);

    if (_isFilling) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: widget.newUserRequest != null
          ? CustomAppBar(title: local.newUserRequestDetails, backBtn: true)
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, __) => Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                CustomTextFieldWidget(
                  controller: _titleController,
                  label: local.title,
                  validator: (v) => CommonTextFieldForm.textFormFieldValidation(
                      v, local.pleaseEnterTitle),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFieldWidget(
                        controller: _joiningDateController,
                        label: local.joiningDate,
                        readOnly: true,
                        validator: (v) =>
                            CommonTextFieldForm.textFormFieldValidation(
                                v, local.pleaseEnterJoiningDate),
                      ),
                    ),
                    Center(
                      child: IconButton(
                          onPressed: pickDate,
                          icon: const Icon(Icons.calendar_month_rounded)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _locationController,
                  label: local.locationStr,
                  validator: (v) => CommonTextFieldForm.textFormFieldValidation(
                      v, local.pleaseEnterLocation),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _englishNameController,
                  label: local.enName,
                  validator: (v) => CommonTextFieldForm.textFormFieldValidation(
                      v, local.pleaseEnterEnName),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _arabicNameController,
                  label: local.arName,
                  validator: (v) => CommonTextFieldForm.textFormFieldValidation(
                      v, local.pleaseEnterArName),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _jobTitleController,
                  label: local.jobTitlesStr,
                  validator: (v) => CommonTextFieldForm.textFormFieldValidation(
                      v, local.pleaseEnterJobTitle),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _mobileNumberController,
                  label: local.phoneNo,
                  validator: (v) => CommonTextFieldForm.textFormFieldValidation(
                      v, local.pleaseEnterPhoneNo),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _departmentController,
                  label: local.departmentName,
                  validator: (v) => CommonTextFieldForm.textFormFieldValidation(
                      v, local.pleaseEnterDepartment),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _directManagerController,
                  label: local.directManager,
                  readOnly: true,
                  validator: CommonTextFieldForm.optional,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomDropDownFieldWidget(
                  value: selectedDeviceType,
                  items: deviceTypes,
                  label: local.deviceRequestedType,
                  validator: (v) => CommonTextFieldForm.textFormFieldValidation(
                      v, local.pleaseEnterDeviceType),
                  onChanged: (v) => setState(() => selectedDeviceType = v),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _laptopNeedForApprovalController,
                  label: local.laptopBusinessNeedForApproval,
                  maxLines: 4,
                  validator: CommonTextFieldForm.optional,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomDropDownFieldWidget(
                  value: selectedNewEmail,
                  items: newEmailRequests,
                  label: local.newEmailRequested,
                  validator: (v) => CommonTextFieldForm.textFormFieldValidation(
                      v, local.pleaseEnterNeedNewEMail),
                  onChanged: (v) => setState(() => selectedNewEmail = v),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _currentMailToUseController,
                  label: local.currentEmailToUse,
                  validator: CommonTextFieldForm.optional,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _specifyNeedForNewMailController,
                  label: local.specifyTheBusinessNeedForNewEmail,
                  maxLines: 4,
                  validator: CommonTextFieldForm.optional,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomDropDownFieldWidget(
                  value: selectedUseDynamics,
                  items: yesNoList,
                  label: local.requestPhoneLine,
                  validator: CommonTextFieldForm.optional,
                  onChanged: (v) => setState(() => selectedUseDynamics = v),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomDropDownFieldWidget(
                  value: selectNeedPhone,
                  items: yesNoList,
                  label: local.requestAnAccountForMSDynamics,
                  validator: CommonTextFieldForm.optional,
                  onChanged: (v) => setState(() => selectNeedPhone = v),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _specifyRoleDynamicsController,
                  label: local.specifyTheRoleMSDynamices,
                  maxLines: 4,
                  validator: CommonTextFieldForm.optional,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _requestSpecialSpecsController,
                  label: local.requestSpecialSpecsForApproval,
                  maxLines: 4,
                  validator: CommonTextFieldForm.optional,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFieldWidget(
                  controller: _specificSoftwareNeededController,
                  label: local.specificSoftwareNeeded,
                  maxLines: 4,
                  validator: CommonTextFieldForm.optional,
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: double.infinity,
                  child: SubmitButton(
                    btnText: widget.newUserRequest != null
                        ? local.update
                        : local.submit,
                    btnFunction:
                        // widget.newUserRequest != null ?
                        () => _submitForm(local, newUserRequestProvider),
                    // : _updateForm(),
                    loading: _isLoading,
                  ),
                ),
              ],
            ),
            itemCount: 1,
          ),
        ),
      ),
    );
  }

  Future<void> fillForm(BuildContext context) async {
    final request = widget.newUserRequest;
    if (request == null) return;

    setState(() => _isFilling = true);

    try {
      _titleController.text = request.title ?? '';
      _joiningDateController.text = DateFormat('dd-MM-yyyy', context.currentLocale()).format(request.joiningDate!);
      _locationController.text = request.location ?? '';
      _englishNameController.text = request.enName ?? '';
      _arabicNameController.text = request.arName ?? '';
      _jobTitleController.text = request.jobTitle ?? '';
      _mobileNumberController.text = request.phoneNo ?? '';
      _departmentController.text = request.department ?? '';
      _laptopNeedForApprovalController.text = request.laptopNeeds ?? '';
      _requestSpecialSpecsController.text = request.specialSpecs ?? '';
      _specificSoftwareNeededController.text = request.specificSoftware ?? '';
      _currentMailToUseController.text = request.currentEmailToUse ?? '';
      _specifyNeedForNewMailController.text = request.specifyNeedForNewEmail ?? '';
      _specifyRoleDynamicsController.text = request.specifyDynamicsRole ?? '';

      selectedDeviceType = request.deviceRequestType ?? '';
      selectedNewEmail = request.newEmailRequest ?? '';
      selectedUseDynamics = request.requestDynamicsAccount ?? '';
      selectNeedPhone = request.requestPhoneLine ?? '';
    } catch (e) {
      debugPrint("Error filling form: $e");
    } finally {
      setState(() => _isFilling = false);
    }
  }

}

_updateForm() {}
