import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:company_portal/utils/export_import.dart';
class EcommerceScFormScreen extends StatelessWidget {
  final String userName;
  final int ensureUserId;

  EcommerceScFormScreen({
    required this.userName,
    required this.ensureUserId,
    super.key,
  });

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final fileController = context.read<FileController>();
    final formBloc = context.read<ECommerceFormBloc>();

    return BlocConsumer<ECommerceFormBloc, EcommerceFormState>(
      listener: (BuildContext context, EcommerceFormState state) {
        if(state.isSuccess){
          titleController.clear();
          descriptionController.clear();
          fileController.clear();
          AppNotifier.snackBar(context, local.fromSubmittedSuccessfully, SnackBarType.success);
        } else if (state.errorMessage != null) {
          AppNotifier.snackBar(context, state.errorMessage ?? "", SnackBarType.error);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      CustomTextField(
                        controller: titleController,
                        label: local.title,
                        validator: (v) => TextFieldHelper.optional(""),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: descriptionController,
                        label: local.description,
                        maxLines: 3,
                        validator: (v) => TextFieldHelper.optional(""),
                      ),
                      const SizedBox(height: 16),
                      CustomDropDownField(
                        value: state.selectedPriority,
                        label: local.priority,
                        onChanged: (val) => formBloc.add(ChangeEcommercePriorityEvent(val!)),
                        validator: (v) => TextFieldHelper.textFormFieldValidation(v, local.pleaseSelectPriority),
                        items: getPriorities(local),
                      ),
                      const SizedBox(height: 16),
                      CustomDropDownField(
                        value: state.selectedApp,
                        label: local.app,
                        onChanged: (val) => formBloc.add(ChangeEcommerceAppEvent(val!)),
                        validator: (v) => TextFieldHelper.textFormFieldValidation(v, local.pleaseSelectApp),
                        items: getAppList(local),
                      ),
                      const SizedBox(height: 16),
                      CustomDropDownField(
                        value: state.selectedType,
                        label: local.type,
                        onChanged: (val) => formBloc.add(ChangeEcommerceTypeEvent(val!)),
                        items: getTypeList(local),
                      ),
                      const SizedBox(height: 16),
                      const AttachmentPicker(),
                      const SizedBox(height: 16),
                    ],),
                  ),
                ),
                const SizedBox(height: 10),
                SubmitButton(
                  btnText: local.submit,
                  loading: state.isLoading,
                  btnFunction: () async {
                    if(!_formKey.currentState!.validate()) return;
                    formBloc.add(CreateEcommerceItemEvent(
                      userId: ensureUserId,
                      title: titleController.text,
                      description: descriptionController.text,
                      selectedApp: state.selectedApp,
                      selectedPriority: state.selectedPriority,
                      selectedType: state.selectedType,
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
