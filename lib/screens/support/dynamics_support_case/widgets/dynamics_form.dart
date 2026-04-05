import 'package:company_portal/screens/support/dynamics_support_case/bloc/dynamics_form_bloc/dynamics_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/export_import.dart';

class DynamicsForm extends StatelessWidget {
  DynamicsForm({required this.ensureUser,super.key});
  final int ensureUser;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final areaController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final fileController = context.read<FileController>();
    final formBloc = context.read<DynamicsFormBloc>();

    return BlocConsumer<DynamicsFormBloc, DynamicsFormState>(
      listener: (context, state) {
        if(state.isSuccess){
          titleController.clear();
          descriptionController.clear();
          areaController.clear();
          dateController.clear();
          fileController.clear();
          AppNotifier.snackBar(context, local.fromSubmittedSuccessfully, SnackBarType.success);
        }else if (state.errorMessage != null) {
          AppNotifier.snackBar(context, state.errorMessage ?? "", SnackBarType.error);
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: titleController,
                        label: local.title,
                        validator: (v) => TextFieldHelper.optional(""),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: CustomTextField(
                            key: const ValueKey('joiningDateField'),
                            controller: dateController,
                            label: local.date,
                            readOnly: true,
                            validator: (v) =>
                                TextFieldHelper.textFormFieldValidation(
                                    v, local.pleaseEnterDate),
                          )),
                          Align(
                            alignment: Alignment.topCenter,
                            child: IconButton(
                                onPressed: () async{
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2100),
                                  );
                                  if(!context.mounted) return;
                                  if (picked != null) {
                                    dateController.text = DatesHelper.dashedFormatting(picked, context.currentLocale());                                  }
                                },
                                icon: const Icon(Icons.calendar_month_rounded)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: descriptionController,
                        label: local.description,
                        maxLines: 3,
                        validator: (val) => TextFieldHelper.textFormFieldValidation(
                            val, local.pleaseEnterYourDescription),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: areaController,
                        label: local.area,
                        validator: (val) => TextFieldHelper.textFormFieldValidation(
                            val, local.enterArea),
                      ),
                      const SizedBox(height: 16),
                      CustomDropDownField(
                        value: state.selectedPriority,
                        label: local.priority,
                        onChanged: (val) => formBloc.add(ChangePriorityEvent(val)),
                        validator: (val) => TextFieldHelper.textFormFieldValidation(
                            val, local.pleaseSelectPriority),
                        items: getPriorities(local),
                      ),
                      const SizedBox(height: 16),
                      CustomDropDownField(
                        value: state.selectedPurpose,
                        label: local.purpose,
                        onChanged: (val) => formBloc.add(ChangePurposeEvent(val)),
                        validator: (val) => TextFieldHelper.textFormFieldValidation(
                            val, local.pleaseSelectPurpose),
                        items: getPurpose(local),
                      ),
                      const SizedBox(height: 16),
                      const AttachmentPicker(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SubmitButton(
                btnText: local.submit,
                loading: state.isLoading,
                btnFunction: () async {
                  if (!formKey.currentState!.validate()) return;
                  formBloc.add(CreateDynamicsItemEvent(
                    userId: ensureUser,
                    title: titleController.text,
                    description: descriptionController.text,
                    selectedPriority: state.selectedPriority!,
                    selectedArea: areaController.text,
                    selectedPurpose: state.selectedPurpose!,
                    dateReported: dateController.text,
                    attachedFiles: fileController.attachedFiles,
                  ),
                  );
                },
              )
            ],
          ),
        );
      },
);
  }
}
