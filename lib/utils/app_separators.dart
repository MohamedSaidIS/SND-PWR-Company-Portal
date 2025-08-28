import 'package:flutter/material.dart';

class AppSeparators{
  static Widget dividerSeparate(){
    return const Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Divider(
          thickness: 0.3,
          color: Colors.grey,
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
  static Widget infoDivider(ThemeData theme){
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Divider(
        color: theme.colorScheme.outline,
        thickness: 1,
        height: 5,
      ),
    );
  }
  static Widget separator(ThemeData theme) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 1,                 // بيكسل كامل = خط حاد
      width: double.infinity,
      color: theme.colorScheme.outline, // لون ثابت وواضح
    ),
  );
}

