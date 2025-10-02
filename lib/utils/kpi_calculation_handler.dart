import 'dart:math';
import 'package:company_portal/l10n/app_localizations.dart';
import 'package:company_portal/models/remote/sales_kpi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_number/iso.dart';
import 'package:jiffy/jiffy.dart';


import 'app_notifier.dart';

class KpiCalculationHandler {
  final AppLocalizations local;

  KpiCalculationHandler(this.local);

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

    AppNotifier.logWithScreen("KpiCalculation Handler","Last KPI Date: ${lastKpi.transDate} Sales: ${lastKpi.dailySalesAmount}");

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

    AppNotifier.logWithScreen("KpiCalculation Handler","Filtered Data: ${filteredData.length}");

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

  static List<DailyKPI> calculateDailySalesPerWeek(List<SalesKPI> data, int currentWeek, int year, List<DailyKPI> weeklyValues) {
    final start = getIsoWeekStart(year, currentWeek);
    final end = getIsoWeekEnd(year, currentWeek);

    AppNotifier.logWithScreen("KpiCalculation Handler","Start: $start, End: $end");

    // final List<DailyKPI> weeklyValues = List.generate(7, (index) {
    //   final date = start.add(Duration(days: index));
    //   return DailyKPI(
    //     dayName: getDayName(date.weekday),
    //     date: date,
    //     totalSales: 0,
    //   );
    // });

    DateTime onlyDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

    final startOnlyDate = onlyDate(start);
    final endOnlyDate = onlyDate(end);

    final weekData = data.where((e) {
      final d = onlyDate(e.transDate);
      return d.isAtSameMomentAs(startOnlyDate) ||
          d.isAtSameMomentAs(endOnlyDate) ||
          (d.isAfter(startOnlyDate) && d.isBefore(endOnlyDate));
    });

    AppNotifier.logWithScreen("KpiCalculation Handler","weekData count: ${weekData.length}");

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

  static int daysInMonthForYear(int year, int month) {
    var beginningNextMonth = (month < 12)
        ? DateTime(year, month + 1, 1)
        : DateTime(year + 1, 1, 1);
    return beginningNextMonth.subtract(const Duration(days: 1)).day;
  }

  static List<DailyKPI> calculateDailySalesPerMonth(List<SalesKPI> data, int month, int year) {
    final start = DateTime(year, month, 1);
    final totalDays = daysInMonthForYear(year, month);
    final end = DateTime(year, month, totalDays);

    AppNotifier.logWithScreen("KpiCalculation Handler","Month Start: $start, End: $end");

    final daysInMonth = List.generate(end.day, (index) {
      final date = DateTime(year, month, index + 1);
      return DailyKPI(
        dayName: getDayNameForMonth(date.weekday),
        date: date,
        totalSales: 0,
      );
    });

    DateTime onlyDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

    final monthData = data.where((e) {
      final d = onlyDate(e.transDate);
      return (d.isAtSameMomentAs(start) || d.isAtSameMomentAs(end)) ||
          (d.isAfter(start) && d.isBefore(end));
    });

    AppNotifier.logWithScreen("KpiCalculation Handler","monthData count: ${monthData.length}");

    for (var kpi in monthData) {
      final dayIndex = kpi.transDate.day - 1;
      final old = daysInMonth[dayIndex];
      daysInMonth[dayIndex] = DailyKPI(
        dayName: old.dayName,
        date: old.date,
        totalSales: kpi.dailySalesAmount,
      );
    }

    return daysInMonth.where((e) => e.totalSales > 0).toList();
  }


  static String getMonthName(List<SalesKPI> data, int selectedMonth, bool isArabic) {
    var now = DateTime.now();
    var date = DateTime(now.year, selectedMonth);
    if (data.isNotEmpty) {
      now = data.last.transDate;
      date = DateTime(now.year, selectedMonth);
    }
    AppNotifier.logWithScreen("KpiCalculation Handler","Date: $date");
    final monthName = isArabic ? DateFormat.yMMMM('ar').format(date) : DateFormat.yMMMM().format(date);
    AppNotifier.logWithScreen("KpiCalculation Handler","Month Name: $monthName");
    return monthName;
  }


  static String getLastDayName(List<SalesKPI> data, int selectedMonth, int selectedWeek, bool isArabic) {
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
    final lastDayName = isArabic ? DateFormat.yMMMEd('ar').format(now) : DateFormat.yMMMEd().format(now);
    AppNotifier.logWithScreen("KpiCalculation Handler",lastDayName);
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
    double step = calculateStep(maxVal);
    double roundedMax = (maxVal / step).ceil() * step;

    return roundedMax;
  }

  static double calcWeeklyMaxY(List<DailyKPI> data) {
    if (data.isEmpty) return 0;

    final maxVal = data.map((e) => e.totalSales).reduce(max);
    double step = calculateStep(maxVal);
    double roundedMax = (maxVal / step).ceil() * step;

    return roundedMax;
  }

  static double calcMonthlyMaxY(List<WeeklyKPI> data) {
    if (data.isEmpty) return 0;

    final maxVal = data.map((e) => e.totalSales).reduce(max);
    double step = calculateStep(maxVal);
    double roundedMax = (maxVal / step).ceil() * step;

    return roundedMax;
  }
  static double calculateStep(double maxVal) {
    if (maxVal <= 10000) return 1000;
    if (maxVal <= 50000) return 5000;
    if (maxVal <= 200000) return 10000;
    if (maxVal <= 1000000) return 50000;
    return 100000;
  }

  static List<DailyKPI> generateDays(DateTime start, AppLocalizations local){
    final List<DailyKPI> weeklyValues = List.generate(7, (index) {
      final date = start.add(Duration(days: index));
      return DailyKPI(
        dayName: getDayName(date.weekday, local),
        date: date,
        totalSales: 0,
      );
    });
    return weeklyValues;
  }

  static String getDayName(int weekday, AppLocalizations local) {
    switch (weekday) {
      case DateTime.monday:
        return local.mon;
      case DateTime.tuesday:
        return local.tue;
      case DateTime.wednesday:
        return local.wed;
      case DateTime.thursday:
        return local.thu;
      case DateTime.friday:
        return local.fri;
      case DateTime.saturday:
        return local.sat;
      case DateTime.sunday:
        return local.sun;
      default:
        return "";
    }
  }

  static String getDayNameForMonth(int weekday) {
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
