import 'package:company_portal/screens/support/features/user_new_requests/bloc/new_user_form_bloc/new_user_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:company_portal/utils/export_import.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/additional_request_section.dart';
import '../widgets/basic_info_section.dart';
import '../widgets/device_email_section.dart';
import '../widgets/employee_info_section.dart';

class UserNewRequestFormScreen extends StatefulWidget {
  final String userName;
  final int ensureUserId;
  final NewUserItem? newUserItem;

  const UserNewRequestFormScreen({
    super.key,
    required this.userName,
    required this.ensureUserId,
    required this.newUserItem,
  });

  @override
  State<UserNewRequestFormScreen> createState() =>
      _UserNewRequestFormScreenState();
}

class _UserNewRequestFormScreenState extends State<UserNewRequestFormScreen> {
  late final UserNewRequestFormController controller;

  @override
  void initState() {
    super.initState();
    AppNotifier.logWithScreen("UserNewRequestFormScreen","Request ${widget.newUserItem}");
    controller = UserNewRequestFormController(widget.newUserItem, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final formBloc = context.read<NewUserFormBloc>();

    return Scaffold(
      appBar: (widget.newUserItem != null) ? CustomAppBar(title: local.newUserRequestDetails, backBtn: true,) : null,
      body: SafeArea(
        child: BlocConsumer<NewUserFormBloc, NewUserFormState>(
          listener: (context, state) {
            if(state.status == FormStatus.success){
              controller.clearData();
              AppNotifier.snackBar(context, local.fromSubmittedSuccessfully, SnackBarType.success);
            }
            else if(state.status == FormStatus.error){
              AppNotifier.snackBar(context, local.somethingWentWrong, SnackBarType.error);
            }
          },
          builder: (context, state) {
            if (state.isFilling) {
              return AppNotifier.loadingWidget(theme);
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: controller.formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            BasicInfoSection(controller: controller),
                            EmployeeInfoSection(controller: controller),
                            DeviceEmailSection(controller: controller),
                            AdditionalRequestSection(controller: controller),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SubmitButton(
                      btnText: widget.newUserItem != null ? local.update : local.submit,
                      loading: state.status == FormStatus.loading,
                      btnFunction: () async {
                        if(!controller.formKey.currentState!.validate()) return;
                        final item = controller.buildRequest(ensureUserId: widget.ensureUserId, state: state);
                        formBloc.add(SubmitNewUserFormEvent(item: item));
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

  }
}
