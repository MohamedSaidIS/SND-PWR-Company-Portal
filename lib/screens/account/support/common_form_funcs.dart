import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CommonTextFieldForm{
  static String? textFormFieldValidation(String? value, String validateText) {
    return (value == null || value.trim().isEmpty) ? validateText : null;
  }

  static InputDecoration textFormFieldDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
    );
  }

  static DropdownStyleData dropDownDecoration() {
    return DropdownStyleData(
      isOverButton: false,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}