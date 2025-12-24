import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../../utils/export_import.dart';

class CustomDropDownField extends StatelessWidget {
  final String? value;
  final String label;
  final String? Function(String?)? validator;
  final ValueChanged<String?> onChanged;
  final List<Map<String, String>> items;

  const CustomDropDownField(
      {super.key,
      required this.value,
      required this.label,
      this.validator,
      required this.onChanged,
      required this.items});

  @override
  Widget build(BuildContext context) {
    final local = context.local;

    return DropdownButtonFormField2(
      key: key,
      value: value,
      isExpanded: true,
      items: items
          .map((e) =>
              DropdownMenuItem(value: e['value'], child: Text(e['label']!)))
          .toList(),
      decoration: TextFieldHelper.textFormFieldDecoration(label, local),
      dropdownStyleData: TextFieldHelper.dropDownDecoration(),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
