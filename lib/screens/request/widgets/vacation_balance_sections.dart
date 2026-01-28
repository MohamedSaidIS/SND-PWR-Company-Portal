import 'package:flutter/material.dart';
import '../../../utils/export_import.dart';

Widget headerSection(String title) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget loadingWidget(ThemeData theme) {
  return SliverToBoxAdapter(child: AppNotifier.loadingWidget(theme));
}

Widget noDataExist(String title, ThemeData theme) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        children: [
          Icon(
            Icons.not_interested_rounded,
            color: theme.colorScheme.secondary,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 15),
          )
        ],
      ),
    ),
  );
}

Row buildHeader(
    ThemeData theme,
    String absenceName,
    VacationTransaction item,
    bool isArabic,
    AppLocalizations local,
    String permissionDuration,
    bool isPermission) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        absenceName,
        style: TextStyle(
            color: theme.colorScheme.secondary, fontWeight: FontWeight.w600),
      ),
      isPermission
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
  );
}

Widget buildDateRow(
  VacationTransaction item,
  AppLocalizations local,
  String locale,
) {
  return Text.rich(
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
  );
}
