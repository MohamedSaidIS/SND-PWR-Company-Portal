import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:to_arabic_number/to_arabic_number.dart';

import '../l10n/app_localizations.dart';

class KpiHelper{
  static String getMonthName(String month, AppLocalizations local) {
    switch (month) {
      case "January":
        return local.january;
      case "February":
        return local.february;
      case "March":
        return local.march;
      case "April":
        return local.april;
      case "May":
        return local.may;
      case "June":
        return local.june;
      case "July":
        return local.july;
      case "August":
        return local.august;
      case "September":
        return local.september;
      case "October":
        return local.october;
      case "November":
        return local.november;
      case "December":
        return local.december;
      default:
        return "";
    }
  }

  static Color getPieChartColor(num percent){
    if(percent >= 100){
      return Colors.green;
    }else if(percent >= 75){
      return Colors.orange;
    }else if(percent >= 50){
      return Colors.amberAccent;
    }else{
      return Colors.red;
    }
  }
}
String convertedToArabicNumber(var weekNumber, isArabic) {
  return isArabic ? Arabic.number(weekNumber.toString()) : weekNumber.toString();
}