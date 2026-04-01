import 'package:company_portal/screens/support/ecommerce_support_case/bloc/e_commerce_bloc/e_commerce_bloc.dart';
import 'package:company_portal/screens/support/ecommerce_support_case/bloc/e_commerce_form_bloc/e_commerce_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/export_import.dart';


class EcommerceForm extends StatefulWidget {
  final int ensureUser;

  const EcommerceForm({required this.ensureUser, super.key});

  @override
  State<EcommerceForm> createState() => _EcommerceFormState();
}

class _EcommerceFormState extends State<EcommerceForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController= TextEditingController();
  String? selectedApp, selectedPriority = "Normal", selectedType;

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final fileController = context.read<FileController>();
    final formBloc = context.read<ECommerceFormBloc>();


    return BlocConsumer<ECommerceFormBloc, ECommerceFormState>(
      listener: (BuildContext context, ECommerceFormState state) {
        if(state is ECommerceFormSuccess){
          titleController.clear();
          descriptionController.clear();
          selectedApp = null;
          selectedPriority = "Normal";
          selectedType = null;
          fileController.clear();
          AppNotifier.snackBar(context, local.fromSubmittedSuccessfully, SnackBarType.success);
        } else if (state is ECommerceFormError) {
          AppNotifier.snackBar(context, state.errorMessage ?? "", SnackBarType.error);
        }
      },
      builder: (context, state) {
        final isLoading = state is ECommerceFormLoading;
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
                      value: selectedPriority,
                      label: local.priority,
                      onChanged: (val) => selectedPriority = val,
                      validator: (v) => TextFieldHelper.textFormFieldValidation(v, local.pleaseSelectPriority),
                      items: getPriorities(local),
                    ),
                    const SizedBox(height: 16),
                    CustomDropDownField(
                      value: selectedApp,
                      label: local.app,
                      onChanged: (val) => selectedApp = val,
                      validator: (v) => TextFieldHelper.textFormFieldValidation(v, local.pleaseSelectApp),
                      items: getAppList(local),
                    ),
                    const SizedBox(height: 16),
                    CustomDropDownField(
                      value: selectedType,
                      label: local.type,
                      onChanged: (val) => selectedType = val,
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
                loading: isLoading,
                btnFunction: () async {
                 if(!_formKey.currentState!.validate()) return;
                 formBloc.add(CreateECommerceItemEvent(
                   userId: widget.ensureUser,
                   title: titleController.text,
                   description: descriptionController.text,
                   selectedApp: selectedApp,
                   selectedPriority: selectedPriority,
                   selectedType: selectedType,
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
