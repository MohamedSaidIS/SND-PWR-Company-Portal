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
  static Widget infoDivider(){
    return const Divider(
      color: Color(0xffff4a01),
      thickness: 0.25,
    );
  }
}

