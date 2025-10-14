import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import '../common_form_funcs.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;

  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    return TextFormField(
      controller: controller,
      decoration: CommonTextFieldForm.textFormFieldDecoration(label, local),
      maxLines: maxLines,
      validator: validator,
      readOnly: readOnly,
    );
  }
}
