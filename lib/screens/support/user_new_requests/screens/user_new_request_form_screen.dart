import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';


class UserNewRequestFormScreen extends StatefulWidget {
  final String userName;
  final int ensureUserId;
  final NewUserRequest? newUserRequest;

  const UserNewRequestFormScreen({
    super.key,
    required this.userName,
    required this.ensureUserId,
    required this.newUserRequest,
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
    AppNotifier.logWithScreen("UserNewRequestFormScreen","Request ${widget.newUserRequest}");
    controller = UserNewRequestFormController(context, widget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    if (controller.isFilling) {
      return Scaffold(
        body: AppNotifier.loadingWidget(theme),
      );
    }

    return Scaffold(
      appBar: (widget.newUserRequest != null) ? CustomAppBar(title: local.newUserRequestDetails, backBtn: true,) : null,
      body: SafeArea(
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
                      buildBasicInfoSection(local, controller, theme),
                      buildEmployeeInfoSection(local, controller, theme),
                      buildDeviceEmailSection(local, controller, theme),
                      buildAdditionalRequestsSection(local, controller, theme),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SubmitButton(
                btnText: widget.newUserRequest != null ? local.update : local.submit,
                loading: controller.isLoading,
                btnFunction: () async {
                  setState(() => controller.isLoading = true);
                  await controller.submitForm(local, widget.newUserRequest, widget.ensureUserId);
                  setState(() => controller.isLoading = false);
                },
              ),
            ],
          ),
        ),
      ),
    );

  }
}
