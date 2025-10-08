import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import '../common_form_funcs.dart';


class UserNewRequestFormScreen extends StatefulWidget {
  final String userName;
  final int ensureUserId;

  const UserNewRequestFormScreen({
    required this.userName,
    required this.ensureUserId,
    super.key,
  });

  @override
  State<UserNewRequestFormScreen> createState() =>
      _UserNewRequestFormScreenState();
}

class _UserNewRequestFormScreenState extends State<UserNewRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _englishNameController = TextEditingController();
  final TextEditingController _arabicNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _directManagerController = TextEditingController();
  final TextEditingController _laptopNeedForApprovalController = TextEditingController();
  final TextEditingController _requestSpecialSpecsController = TextEditingController();
  final TextEditingController _specificSoftwareNeededController = TextEditingController();
  final TextEditingController _currentMailToUseController = TextEditingController();
  final TextEditingController _specifyNeedForNewMailController = TextEditingController();
  final TextEditingController _specifyRoleDynamicsController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(local.title),
                maxLines: 1,
                validator: (value) => CommonTextFieldForm.textFormFieldValidation(value, local.pleaseEnterTitle),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(local.location),
                maxLines: 1,
                validator: (value) => CommonTextFieldForm.textFormFieldValidation(value, local.pleaseEnterLocation),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _englishNameController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(local.enName),
                maxLines: 1,
                validator: (value) => CommonTextFieldForm.textFormFieldValidation(value, local.pleaseEnterEnName),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _arabicNameController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(local.arName),
                maxLines: 1,
                validator: (value) => CommonTextFieldForm.textFormFieldValidation(value, local.pleaseEnterArName),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _jobTitleController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(local.jobTitle),
                maxLines: 1,
                validator: (value) => CommonTextFieldForm.textFormFieldValidation(value, local.pleaseEnterJobTitle),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _mobileNumberController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(local.phoneNo),
                maxLines: 1,
                validator: (value) => CommonTextFieldForm.textFormFieldValidation(value, local.pleaseEnterPhoneNo),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(local.departmentName),
                maxLines: 1,
                validator: (value) => CommonTextFieldForm.textFormFieldValidation(value, local.pleaseEnterDepartment),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _directManagerController,
                decoration: CommonTextFieldForm.textFormFieldDecoration(local.directManager),
                maxLines: 1,
                validator: (value) => CommonTextFieldForm.textFormFieldValidation(value, local.pleaseEnterTitle),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
