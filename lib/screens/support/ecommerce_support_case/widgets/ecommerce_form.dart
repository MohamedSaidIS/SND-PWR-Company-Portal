import 'package:company_portal/screens/support/ecommerce_support_case/bloc/e_commerce_form_bloc/e_commerce_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/export_import.dart';


class EcommerceForm extends StatelessWidget {

  EcommerceForm({required this.ensureUser, super.key});
  final int ensureUser;

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
        return Form(
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
                      onChanged: (val) => formBloc.add(ChangePriorityEvent(val!)),
                      validator: (v) => TextFieldHelper.textFormFieldValidation(v, local.pleaseSelectPriority),
                      items: getPriorities(local),
                    ),
                    const SizedBox(height: 16),
                    CustomDropDownField(
                      value: state.selectedApp,
                      label: local.app,
                      onChanged: (val) => formBloc.add(ChangeAppEvent(val!)),
                      validator: (v) => TextFieldHelper.textFormFieldValidation(v, local.pleaseSelectApp),
                      items: getAppList(local),
                    ),
                    const SizedBox(height: 16),
                    CustomDropDownField(
                      value: state.selectedType,
                      label: local.type,
                      onChanged: (val) => formBloc.add(ChangeTypeEvent(val!)),
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
                   userId: ensureUser,
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
        );
  },
);
  }
}
