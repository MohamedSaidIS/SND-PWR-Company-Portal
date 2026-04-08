import 'package:flutter/material.dart';
import 'package:company_portal/utils/export_import.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DynamicsScFormScreen extends StatelessWidget {
   DynamicsScFormScreen({required this.userName, required this.ensureUserId, super.key,});
   final String userName;
   final int ensureUserId;

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

    return SafeArea(
      child: BlocConsumer<DynamicsFormBloc, DynamicsFormState>(
        listener: (context, state) {
          if(state.status == FormStatus.success){
            titleController.clear();
            descriptionController.clear();
            areaController.clear();
            dateController.clear();
            fileController.clear();
            AppNotifier.snackBar(context, local.fromSubmittedSuccessfully, SnackBarType.success);
          }else if (state.status == FormStatus.error) {
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
                            onChanged: (val) => formBloc.add(ChangeDynamicsPriorityEvent(val)),
                            validator: (val) => TextFieldHelper.textFormFieldValidation(
                                val, local.pleaseSelectPriority),
                            items: getPriorities(local),
                          ),
                          const SizedBox(height: 16),
                          CustomDropDownField(
                            value: state.selectedPurpose,
                            label: local.purpose,
                            onChanged: (val) => formBloc.add(ChangeDynamicsPurposeEvent(val)),
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
                    loading: state.status == FormStatus.loading,
                    btnFunction: () async {
                      if (!formKey.currentState!.validate()) return;
                      formBloc.add(CreateDynamicsItemEvent(
                        userId: ensureUserId,
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
            ),
          );
        },
      ),
    );
  }
}
