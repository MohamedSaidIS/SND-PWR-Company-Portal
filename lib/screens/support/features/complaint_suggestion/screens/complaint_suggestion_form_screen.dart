import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:company_portal/utils/export_import.dart';
class ComplaintSuggestionFormScreen extends StatelessWidget {
  final String userName;
  final int ensureUserId;

  ComplaintSuggestionFormScreen({
    required this.userName,
    required this.ensureUserId,
    super.key,
  });
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final titleController  = TextEditingController();
  final descriptionController  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final fileController = context.read<FileController>();
    final formBloc = context.read<ComplaintFormBloc>();

    return BlocConsumer<ComplaintFormBloc, ComplaintFormState>(
      listener: (context, state) {
        if(state.isSuccess){
          titleController.clear();
          descriptionController.clear();
          fileController.clear();
          AppNotifier.snackBar(context, local.fromSubmittedSuccessfully, SnackBarType.success);
        }else if (state.errorMessage != null) {
          AppNotifier.snackBar(context, state.errorMessage ?? "", SnackBarType.error);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        SendOptionalName(
                          isChecked: state.isChecked,
                          onChange: (val) => formBloc.add(ToggleEvent(val!)),
                          nameController: TextEditingController(text: userName),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RadioButtonSelection(
                                text: local.complaint,
                                groupValue: state.selectedType,
                                value: "Complaint",
                                onChange: (val) => formBloc.add(ChangeComplaintTypeEvent(val!)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RadioButtonSelection(
                                text: local.suggestion,
                                groupValue: state.selectedType,
                                value: "Suggestion",
                                onChange: (val) =>  formBloc.add(ChangeComplaintTypeEvent(val!)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomDropDownField(
                          value: state.selectedCategory,
                          label: local.category,
                          onChanged: (val) => formBloc.add(ChangeComplaintCategoryEvent(val!)),
                          items: getCategories(local),
                          validator: (val) => TextFieldHelper.textFormFieldValidation(
                              val, local.pleaseSelectCategory),
                        ),
                        const SizedBox(height: 16),
                        CustomDropDownField(
                          value: state.selectedPriority,
                          label: local.priority,
                          onChanged: (val) => formBloc.add(ChangeComplaintPriorityEvent(val!)),
                          items: getPriorities(local),
                          validator: (val) => TextFieldHelper.textFormFieldValidation(
                              val, local.pleaseSelectPriority),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: titleController,
                          label: local.issueTitle,
                          maxLines: 2,
                          validator: (value) => TextFieldHelper.textFormFieldValidation(
                              value, local.pleaseEnterTitle),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: descriptionController,
                          label: local.issueDescription,
                          maxLines: 4,
                          validator: (value) => TextFieldHelper.textFormFieldValidation(
                              value, local.pleaseEnterYourDescription),
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
                    if(!formKey.currentState!.validate()) return;
                    formBloc.add(CreateComplaintItemEvent(
                      userId: ensureUserId,
                      title: titleController.text,
                      description: descriptionController.text,
                      selectedPriority: state.selectedPriority,
                      selectedDepartment: state.selectedCategory,
                      userName: state.isChecked ? userName.trim() : '',
                      attachedFiles: fileController.attachedFiles,
                    ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

