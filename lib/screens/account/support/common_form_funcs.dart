import 'package:company_portal/l10n/app_localizations.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CommonTextFieldForm{
  static String? textFormFieldValidation(String? value, String validateText) {
    debugPrint('Validator called for $value -> value: $validateText');
    return (value == null || value.trim().isEmpty) ? validateText : null;
  }

  static String? optional(String? value) => null;

  static InputDecoration textFormFieldDecoration(String labelText, AppLocalizations local) {
    return InputDecoration(
      labelText: labelText,
      hintText: labelText == local.joiningDate? local.selectDate : "",
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