import 'package:flutter/material.dart';

import '../../../../utils/export_import.dart';

class RequestForm extends StatefulWidget {
  final VacationRequestController controller;

  const RequestForm({super.key, required this.controller});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: widget.controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RadioButtonSelection(
                          text: local.vacation,
                          groupValue: widget.controller.selectedType!,
                          value: "Vacation",
                          onChange: (val) {
                            setState(() {
                              widget.controller.selectedType = val;

                              widget.controller.vacationType = null;
                              // widget.controller.vacationDays = 0;
                              // widget.controller.clearDates(); // لو عندك method تمسح التواريخ
                              // widget.controller.allFilesAttached.clear(); // لو فيه مرفقات
                            });
                          }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RadioButtonSelection(
                        text: local.permission,
                        groupValue: widget.controller.selectedType!,
                        value: "Permission",
                        onChange: (val) {
                          setState(() {
                            widget.controller.selectedType = val;

                            widget.controller.vacationType = null;
                            // widget.controller.vacationDays = 0;
                            // widget.controller.clearDates();
                            // widget.controller.allFilesAttached.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: widget.controller.code,
                  label: local.employeeCode,
                  readOnly: true,
                  validator: (v) => TextFieldHelper.textFormFieldValidation(
                      v, local.requiredField),
                ),
                const SizedBox(height: 16),
                CustomDropDownField(
                  value: widget.controller.vacationType,
                  label: local.vacationType,
                  onChanged: (val) {
                    setState(() {
                      widget.controller.vacationType = val;
                    });
                  },
                  validator: (v) => TextFieldHelper.textFormFieldValidation(
                      v, local.requiredField),
                  items: widget.controller.selectedType == "Vacation"
                      ? getVacationCode(local)
                      : getPermissionCode(local),
                ),
                const SizedBox(height: 16),
                VacationDates(
                  controller: widget.controller,
                ),
                const SizedBox(height: 8),
                // widget.controller.selectedType == "Vacation"
                //     ? Text(
                //         '${local.vacationDays}: ${widget.controller.vacationDays}',
                //         style: theme.textTheme.headlineSmall,
                //       )
                //     : const SizedBox.shrink(),
                const SizedBox(height: 8),
                widget.controller.vacationType == "001"
                    ? const AttachmentPicker(isVacationRequest: true,)
                    : const SizedBox.shrink(),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: widget.controller.note,
                  label: local.note,
                  maxLines: 3,
                  validator: (v) => TextFieldHelper.optional(v),
                ),
                const SizedBox(height: 16),
                SubmitButton(
                  btnText: local.submit,
                  loading: widget.controller.isLoading,
                  btnFunction: () async {
                    setState(() => widget.controller.isLoading = true);
                    await widget.controller.submitRequest(context, local);
                    setState(() => widget.controller.isLoading = false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
