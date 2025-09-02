import 'dart:math';
import 'package:company_portal/models/sales_kpi.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:flutter/material.dart';
import 'package:week_number/iso.dart';

class KpiCalculator {

  static double calcMonthly(List<SalesKPI> data) {
    final subList = data.take(4);
    return subList.isNotEmpty ? subList.last.lastSalesAmount : 0;
  }



  static List<String> getCurrentWeekDays(List<SalesKPI> data){
    final now = DateTime(2025, 4, 8);
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    const weekDayNames = {
      1: "Mon",
      2: "Tue",
      3: "Wed",
      4: "Thu",
      5: "Fri",
      6: "Sat",
      7: "Sun",
    };

    final weekDays = data.take(4).toList().map((item){
      return item.transDate;
    }).where((data){
      return data.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          data.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();
    AppNotifier.printFunction("Week Days", "$weekDays");
    return weekDays.map((d)=> weekDayNames[d.weekday] ?? "").toList();
  }

  static List<double> getWeeklyKPIs(List<SalesKPI> data,) {
    final now = DateTime(2025, 4, 8);
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final List<double> weeklyValues = List.filled(7, 0);

    final weekData = data.where((e) =>
    e.transDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        e.transDate.isBefore(endOfWeek.add(const Duration(days: 1))));

    for (var kpi in weekData) {
      final index = kpi.transDate.weekday - 1;
      weeklyValues[index] += kpi.dailySalesAmount;
    }

    return weeklyValues;
  }


  static List<double> getCurrentMonthWeeks(List<SalesKPI> kpis) {
    if (kpis.isEmpty) return [];


    final month = kpis.first.transDate.month;
    final year = kpis.first.transDate.year;

    final daysInMonth = DateUtils.getDaysInMonth(year, month);

    final totalWeeks = ((daysInMonth - 1) ~/ 7) + 1;


    List<double> weeks = List.filled(totalWeeks, 0);

    for (var kpi in kpis) {
      int weekOfMonth = ((kpi.transDate.day - 1) ~/ 7);
      weeks[weekOfMonth] += kpi.dailySalesAmount;
      AppNotifier.printFunction("Weekly Data", "$weekOfMonth ${weeks[weekOfMonth]}");
    }

    return weeks;
  }

  /////////////////////////////////////////////////////////////////////
  static double calculateDailySales(List<SalesKPI> data) {
    if (data.isEmpty) return 0.0;

    final subList = data.take(4).toList();
    subList.sort((a, b) => a.transDate.compareTo(b.transDate));

    return subList.last.dailySalesAmount;
  }

  static int getWeekNumber(DateTime date) {
    return date.weekNumber;
  }

  static List<WeeklyKPI> calculateWeeklySales(List<SalesKPI> data) {
    final Map<int, double> weeklyTotals = {};

    for (var kpi in data.take(4)) {
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

    final subList = data.take(4).toList();
    subList.sort((a, b) => a.transDate.compareTo(b.transDate));

    return subList.isNotEmpty ? subList.last.lastSalesAmount : 0.0;

  }

  static List<DailyKPI> calculateDailySalesPerWeek(List<SalesKPI> data) {
    final now = DateTime(2025, 4, 8);
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    // الأيام السبعة
    final List<DailyKPI> weeklyValues = List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      return DailyKPI(
        dayName: _getDayName(date.weekday),
        date: date,
        totalSales: 0,
      );
    });

    // صفي الداتا الخاصة بالأسبوع
    final weekData = data.where((e) =>
    e.transDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        e.transDate.isBefore(endOfWeek.add(const Duration(days: 1))));

    // اجمع المبيعات في اليوم الصحيح
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

class WeeklyKPI {
  final int weekNumber;
  final double totalSales;

  WeeklyKPI({required this.weekNumber, required this.totalSales});
}

class DailyKPI {
  final String dayName;   // اسم اليوم (Mon, Tue...)
  final DateTime date;    // تاريخ اليوم نفسه
  final double totalSales;

  DailyKPI({
    required this.dayName,
    required this.date,
    required this.totalSales,
  });
}



