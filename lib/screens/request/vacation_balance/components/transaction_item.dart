import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final  VacationTransaction item;
  const TransactionItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {

    final theme = context.theme;
    final local = context.local;
    final locale = context.currentLocale();
    final isArabic = context.isArabic();

    final absenceName = {
      "سنوي-راتب": local.annualLeave,
      "مأمورية": local.mission,
      "001": local.sickLeave,
      "009": local.compensatoryLeave,
      "006": local.umrahLeave,
      "008": local.bereavementLeave,
      "إذن": local.permission
    }[item.absenceCode] ??
        local.annualLeave;

    String permissionDuration = "";
    if(absenceName == local.permission){
      Duration difference = item.endDate.difference(item.startDate);
      int hours = difference.inHours;
      int minutes = difference.inMinutes.remainder(60);
      permissionDuration = "${hours > 0 ? '${convertedToArabicNumber(hours, isArabic)} hr ' : ''}${minutes > 0 ? '${convertedToArabicNumber(minutes, isArabic)} min' : ''}";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    absenceName,
                    style: TextStyle(
                        color: theme.colorScheme.secondary, fontWeight: FontWeight.w600),
                  ),
                  absenceName == local.permission
                      ? Text(
                    permissionDuration,
                    style: TextStyle(color: theme.colorScheme.primary),
                  )
                      : Text(
                    "${convertedToArabicNumber(
                      double.parse(item.durationDays.toString()).round(),
                      isArabic,
                    )} ${local.days}",
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: "${local.from}  ",
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  children: [
                    TextSpan(
                      text: DatesHelper.monthToYearWithoutDayNameFormatted(item.startDate, locale),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "  —  ${local.to}  ",
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    TextSpan(
                      text: DatesHelper.monthToYearWithoutDayNameFormatted(item.startDate, locale),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
