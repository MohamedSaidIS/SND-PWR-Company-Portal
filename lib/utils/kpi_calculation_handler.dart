import 'dart:math';
import 'package:company_portal/models/remote/sales_kpi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_number/iso.dart';
import 'package:jiffy/jiffy.dart';
import 'package:week_of_year/date_week_extensions.dart';

class KpiCalculationHandler {
  static double calculateDailySales(List<SalesKPI> data, int selectedMonth, int selectedWeek) {
    if (data.isEmpty) return 0.0;
    final year = DateTime.now().year;

    final startOfWeek = getIsoWeekStart(year, selectedWeek);
    final endOfWeek = getIsoWeekEnd(year, selectedWeek);

    DateTime onlyDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

    final weekData = data.where((e) {
      final d = onlyDate(e.transDate);
      return !d.isBefore(onlyDate(startOfWeek)) &&
          !d.isAfter(onlyDate(endOfWeek));
    }).toList();

    if (weekData.isEmpty) return 0.0;

    final lastKpi = weekData.reduce((a, b) =>
    onlyDate(a.transDate).isAfter(onlyDate(b.transDate)) ? a : b);

    print("Last KPI Date: ${lastKpi.transDate}, Sales: ${lastKpi.dailySalesAmount}");

    return lastKpi.dailySalesAmount;
  }

  static int getWeekNumber(DateTime date) {
    return date.weekNumber;
  }

  static List<WeeklyKPI> calculateWeeklySales(List<SalesKPI> data, int selectedMonth) {
    final Map<int, double> weeklyTotals = {};

    final filteredData = data.where((e) =>
    e.transDate.month == selectedMonth &&
        e.transDate.year == DateTime.now().year)
        .toList();

    for (var kpi in filteredData) {
      final week = getWeekNumber(kpi.transDate);
      weeklyTotals[week] = (weeklyTotals[week] ?? 0) + kpi.dailySalesAmount;
    }

    return weeklyTotals.entries
        .map((entry) => WeeklyKPI(
              weekNumber: entry.key,
              totalSales: entry.value,
              monthNumber: selectedMonth,
            ))
        .toList()
      ..sort((a, b) => a.weekNumber.compareTo(b.weekNumber));
  }

  static double calculateMonthlySales(List<SalesKPI> data, int selectedMonth) {
    if (data.isEmpty) return 0.0;

    final filteredData = data
        .where((e) =>
            e.transDate.month == selectedMonth &&
            e.transDate.year == DateTime.now().year)
        .toList();

    filteredData.sort((a, b) => a.transDate.compareTo(b.transDate));

    print("Filtered Data: ${filteredData.length}");

    return filteredData.isNotEmpty ? filteredData.last.lastSalesAmount : 0.0;
  }

  static DateTime getIsoWeekStart(int year, int weekNumber) {
    final jan4 = DateTime(year, 1, 4);
    final mondayOfWeek1 = jan4.subtract(Duration(days: jan4.weekday - 1));
    return mondayOfWeek1.add(Duration(days: (weekNumber - 1) * 7));
  }

  static DateTime getIsoWeekEnd(int year, int weekNumber) {
    return getIsoWeekStart(year, weekNumber).add(const Duration(days: 6));
  }

  static List<DailyKPI> calculateDailySalesPerWeek(
      List<SalesKPI> data, int currentWeek, int year) {
    final start = getIsoWeekStart(year, currentWeek);
    final end = getIsoWeekEnd(year, currentWeek);

    print("Start: $start, End: $end");

    final List<DailyKPI> weeklyValues = List.generate(7, (index) {
      final date = start.add(Duration(days: index));
      return DailyKPI(
        dayName: _getDayName(date.weekday),
        date: date,
        totalSales: 0,
      );
    });

    DateTime onlyDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

    final startOnlyDate = onlyDate(start);
    final endOnlyDate = onlyDate(end);

    final weekData = data.where((e) {
      final d = onlyDate(e.transDate);
      return d.isAtSameMomentAs(startOnlyDate) ||
          d.isAtSameMomentAs(endOnlyDate) ||
          (d.isAfter(startOnlyDate) && d.isBefore(endOnlyDate));
    });

    print("weekData count: ${weekData.length}");

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

  static String getMonthName(List<SalesKPI> data, int selectedMonth) {
    var now = DateTime.now();
    var date = DateTime(now.year);
    if (data.isNotEmpty) {
      now = data.last.transDate;
      date = DateTime(now.year, selectedMonth);
    }
    final monthName = DateFormat.yMMMM().format(date);
    print(monthName);
    return monthName;
  }

  static String getLastDayName(List<SalesKPI> data, int selectedMonth, int selectedWeek) {
    if (data.isEmpty) return "";

    final startOfWeek = getIsoWeekStart(DateTime.now().year, selectedWeek);
    final endOfWeek = getIsoWeekEnd(DateTime.now().year, selectedWeek);

    DateTime onlyDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

    final weekData = data.where((e) {
      final d = onlyDate(e.transDate);
      return !d.isBefore(onlyDate(startOfWeek)) &&
          !d.isAfter(onlyDate(endOfWeek));
    }).toList();

    if(weekData.isEmpty) return "";

    final lastKpi = weekData.reduce((a, b) =>
        onlyDate(a.transDate).isAfter(onlyDate(b.transDate)) ? a : b);

    var now = DateTime.now();
    if (weekData.isNotEmpty) {
      now = lastKpi.transDate;
    }
    final lastDayName = DateFormat.yMMMEd().format(now);
    print(lastDayName);
    return lastDayName;
  }

  static List<int> getWeekNumbersInMonth(int year, int month) {
    final startOfMonth =
        Jiffy.parse('$year-${month.toString().padLeft(2, '0')}-01').dateTime;
    final endOfMonth =
        Jiffy.parse('$year-${month.toString().padLeft(2, '0')}-01')
            .endOf(Unit.month)
            .dateTime;

    List<int> weekNumbers = [];

    DateTime current = startOfMonth;

    while (
        current.isBefore(endOfMonth) || current.isAtSameMomentAs(endOfMonth)) {
      final weekNum = Jiffy.parseFromDateTime(current).weekOfYear;

      if (!weekNumbers.contains(weekNum)) {
        weekNumbers.add(weekNum);
      }

      current = current.add(const Duration(days: 7));
    }

    return weekNumbers;
  }

  /// //////////////////////////////////////////////////////////////////--------------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  static double calcDailyMaxY(List<SalesKPI> data) {
    if (data.isEmpty) return 0;

    final maxVal = data.map((e) => e.dailySalesAmount).reduce(max);
    return (maxVal + 1000).ceil().toDouble();
  }

  static double calcWeeklyMaxY(List<SalesKPI> data) {
    if (data.isEmpty) return 0;

    final maxVal = data.map((e) => e.dailySalesAmount).reduce(max);
    return (maxVal + 1000).ceil().toDouble();
  }

  static double calcMonthlyMaxY(List<WeeklyKPI> data) {
    if (data.isEmpty) return 0;

    final maxVal = data.map((e) => e.totalSales).reduce(max);
    return (maxVal + 1000).ceil().toDouble();
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
  final int monthNumber;

  WeeklyKPI(
      {required this.weekNumber,
      required this.totalSales,
      required this.monthNumber});
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
