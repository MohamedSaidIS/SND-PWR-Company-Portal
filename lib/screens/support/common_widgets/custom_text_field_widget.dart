import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final TextInputType inputType;

  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    return TextFormField(
      key: key,
      controller: controller,
      decoration: CommonTextFieldForm.textFormFieldDecoration(label, local),
      keyboardType: inputType,
      maxLines: maxLines,
      validator: validator,
      readOnly: readOnly,
    );
  }
}
