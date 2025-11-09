import 'package:flutter/material.dart';
import '../../../../utils/export_import.dart';

class SendOptionalName extends StatelessWidget {
  final bool isChecked;
  final Function(dynamic val) onChange;
  final TextEditingController nameController;
  const SendOptionalName({required this.isChecked, required this.onChange, required this.nameController, super.key,});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final isArabic = context.isArabic();

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: nameController,
            decoration: CommonTextFieldForm.textFormFieldDecoration(
                local.nameOptional, local),
            enabled: false,
            readOnly: true,
          ),
        ),
        IntrinsicWidth(
          child: CheckboxListTile(
            activeColor: theme.colorScheme.secondary,
            value: isChecked,
            onChanged: onChange,
            checkColor: theme.colorScheme.surface,
            checkboxShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Transform.translate(
              offset: Offset(isArabic ? 20 :-20, 0),
              child: Text(local.showName),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        )
      ],
    );
  }
}
