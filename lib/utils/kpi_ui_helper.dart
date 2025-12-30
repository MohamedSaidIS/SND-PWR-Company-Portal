import 'package:flutter/material.dart';
import 'package:to_arabic_number/to_arabic_number.dart';
import 'export_import.dart';

class KpiUIHelper{

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

  static Color getDailyKPiBarColor(DailyKPI kpi , double monthlyTarget) {
    Color wantedColor = Colors.blue;
    double dailyTarget = monthlyTarget / 30;

    if (kpi.totalSales > dailyTarget) {
      wantedColor = Colors.blue;
    } else if (kpi.totalSales == dailyTarget) {
      wantedColor = Colors.green;
    } else if (kpi.totalSales > dailyTarget / 2 && kpi.totalSales < dailyTarget) {
      wantedColor = Colors.orange;
    } else if(kpi.totalSales < dailyTarget / 2){
      wantedColor = Colors.red;
    }
    return wantedColor;
  }

  static Color getWeeklyKPiBarColor(DailyKPI kpi, double monthlyTarget) {
    Color wantedColor = Colors.blue;
    double weeklyTarget = monthlyTarget / 4 ;

    if (kpi.totalSales > weeklyTarget) {
      wantedColor = Colors.blue;
    } else if (kpi.totalSales == weeklyTarget) {
      wantedColor = Colors.green;
    } else if (kpi.totalSales > weeklyTarget / 2 && kpi.totalSales < weeklyTarget ) {
      wantedColor = Colors.orange;
    } else if (kpi.totalSales < weeklyTarget / 2 ) {
      wantedColor = Colors.red;
    }
    return wantedColor;
  }

  static Color getMonthlyKPiBarColor(WeeklyKPI kpi, double monthlyTarget) {
    Color wantedColor = Colors.blue;

    if (kpi.totalSales > monthlyTarget) {
      wantedColor = Colors.blue;
    } else if (kpi.totalSales == monthlyTarget) {
      wantedColor = Colors.green;
    } else if (kpi.totalSales > monthlyTarget / 2 && kpi.totalSales < monthlyTarget) {
      wantedColor = Colors.orange;
    } else if (kpi.totalSales < monthlyTarget / 2) {
      wantedColor = Colors.orange;
    }
    return wantedColor;
  }
}


String convertedToArabicNumber(var weekNumber, isArabic) {
  return isArabic ? Arabic.number(weekNumber.toString()) : weekNumber.toString();
}
