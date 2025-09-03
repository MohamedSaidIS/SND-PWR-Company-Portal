import 'dart:math';
import 'package:company_portal/models/remote/sales_kpi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_number/iso.dart';

class KpiCalculationHandler {

  static double calculateDailySales(List<SalesKPI> data) {
    if (data.isEmpty) return 0.0;

    data.sort((a, b) => a.transDate.compareTo(b.transDate));

    return data.last.dailySalesAmount;
  }

  static int getWeekNumber(DateTime date) {
    return date.weekNumber;
  }

  static List<WeeklyKPI> calculateWeeklySales(List<SalesKPI> data) {
    final Map<int, double> weeklyTotals = {};

    for (var kpi in data) {
      final week = getWeekNumber(kpi.transDate);
      weeklyTotals[week] = (weeklyTotals[week] ?? 0) + kpi.dailySalesAmount;
    }

    return weeklyTotals.entries
        .map((entry) =>
        WeeklyKPI(weekNumber: entry.key, totalSales: entry.value
        )).toList()
      ..sort((a, b) => a.weekNumber.compareTo(b.weekNumber));
  }

  static double calculateMonthlySales(List<SalesKPI> data) {
    if (data.isEmpty) return 0.0;

    data.sort((a, b) => a.transDate.compareTo(b.transDate));

    return data.isNotEmpty ? data.last.lastSalesAmount : 0.0;

  }

  static List<DailyKPI> calculateDailySalesPerWeek(List<SalesKPI> data) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final List<DailyKPI> weeklyValues = List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      return DailyKPI(
        dayName: _getDayName(date.weekday),
        date: date,
        totalSales: 0,
      );
    });


    final weekData = data.where((e) =>
    e.transDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        e.transDate.isBefore(endOfWeek.add(const Duration(days: 1))));

    for (var kpi in weekData) {
      final index = kpi.transDate.weekday - 1;
      final old = weeklyValues[index];
      weeklyValues[index] = DailyKPI(
        dayName: old.dayName,
        date: old.date,
        totalSales: old.totalSales + kpi.dailySalesAmount,
      );
    }

    return weeklyValues;
  }

  static String getMonthName(List<SalesKPI> data) {
    final now = data.last.transDate;
    final monthName = DateFormat.yMMMM().format(now); // September
    print(monthName);
    return monthName;
  }

  static String getLastDayName(List<SalesKPI> data) {
    final now = data.last.transDate;
    final lastDayName = DateFormat.yMMMEd().format(now); // September
    print(lastDayName);
    return lastDayName;
  }

  /// //////////////////////////////////////////////////////////////////--------------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  static double calcDailyMaxY(List<SalesKPI> data) {
    if (data.isEmpty) return 0;

    final maxVal = data.map((e) => e.dailySalesAmount).reduce(max);
    return (maxVal + 5).ceil().toDouble();
  }

  static double calcWeeklyMaxY(List<SalesKPI> data) {
    if (data.isEmpty) return 0;

    final maxVal = data.map((e) => e.dailySalesAmount).reduce(max);
    return (maxVal + 5).ceil().toDouble();
  }

  static double calcMonthlyMaxY(List<WeeklyKPI> data) {
    if (data.isEmpty) return 0;

    final maxVal = data.map((e) => e.totalSales).reduce(max);
    return (maxVal + 5).ceil().toDouble();
  }

  static String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Mon";
      case DateTime.tuesday:
        return "Tue";
      case DateTime.wednesday:
        return "Wed";
      case DateTime.thursday:
        return "Thu";
      case DateTime.friday:
        return "Fri";
      case DateTime.saturday:
        return "Sat";
      case DateTime.sunday:
        return "Sun";
      default:
        return "";
    }
  }

  /// //////////////////////////////////////////////////////////////////--------------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  static Color getDailyKPiBarColor(SalesKPI kpi) {
    Color wantedColor = Colors.blue;
    if (kpi.dailySalesAmount > kpi.monthlyTarget / 30) {
      wantedColor = Colors.green;
    } else if (kpi.dailySalesAmount == kpi.monthlyTarget / 30) {
      wantedColor = Colors.blue;
    } else if (kpi.dailySalesAmount < kpi.monthlyTarget / 30) {
      wantedColor = Colors.orange;
    } else if (kpi.dailySalesAmount == 0) {
      wantedColor = Colors.red;
    }
    return wantedColor;
  }

  static Color getWeeklyKPiBarColor(SalesKPI kpi) {
    Color wantedColor = Colors.blue;
    if (kpi.dailySalesAmount > kpi.monthlyTarget / 4) {
      wantedColor = Colors.green;
    } else if (kpi.dailySalesAmount == kpi.monthlyTarget / 4) {
      wantedColor = Colors.blue;
    } else if (kpi.dailySalesAmount < kpi.monthlyTarget / 4) {
      wantedColor = Colors.orange;
    } else if (kpi.dailySalesAmount == 0) {
      wantedColor = Colors.red;
    }
    return wantedColor;
  }

  static Color getMonthlyKPiBarColor(SalesKPI kpi) {
    Color wantedColor = Colors.blue;
    if (kpi.dailySalesAmount > kpi.monthlyTarget) {
      wantedColor = Colors.green;
    } else if (kpi.dailySalesAmount == kpi.monthlyTarget) {
      wantedColor = Colors.blue;
    } else if (kpi.dailySalesAmount < kpi.monthlyTarget) {
      wantedColor = Colors.orange;
    } else if (kpi.dailySalesAmount == 0) {
      wantedColor = Colors.red;
    }
    return wantedColor;
  }
}

/// //////////////////////////////////////////////////////////////////--------------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

class WeeklyKPI {
  final int weekNumber;
  final double totalSales;

  WeeklyKPI({required this.weekNumber, required this.totalSales});
}

class DailyKPI {
  final String dayName;
  final DateTime date;
  final double totalSales;

  DailyKPI({
    required this.dayName,
    required this.date,
    required this.totalSales,
  });
}



