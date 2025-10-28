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
    print("Request ${widget.newUserRequest}");
    controller = UserNewRequestFormController(context, widget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    if (controller.isFilling) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.1),
      appBar: (widget.newUserRequest != null) ? CustomAppBar(title: local.newUserRequestDetails, backBtn: true,) : null,
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildBasicInfoSection(local, controller, theme),
                buildEmployeeInfoSection(local, controller, theme),
                buildDeviceEmailSection(local, controller, theme),
                buildAdditionalRequestsSection(local, controller, theme),
                const SizedBox(height: 12),
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
      ),
    );

  }
}
