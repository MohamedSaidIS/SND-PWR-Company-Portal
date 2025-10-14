import 'package:company_portal/utils/context_extensions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../common_form_funcs.dart';

class CustomDropDownFieldWidget extends StatelessWidget {
  final String? value;
  final String label;
  final String? Function(String?)? validator;
  final ValueChanged<String?> onChanged;
  final List<Map<String, String>> items;

  const CustomDropDownFieldWidget({
    super.key,
    required this.value,
    required this.label,
    this.validator,
    required this.onChanged,
    required this.items
  });

  @override
  Widget build(BuildContext context) {
    final local = context.local;

    return DropdownButtonFormField2(
      value: value,
      isExpanded: true,
      items: items
          .map((e) =>
              DropdownMenuItem(value: e['value'], child: Text(e['label']!)))
          .toList(),
      decoration: CommonTextFieldForm.textFormFieldDecoration(label, local),
      dropdownStyleData: CommonTextFieldForm.dropDownDecoration(),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
