import 'package:company_portal/screens/request/widgets/balance_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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

Widget transactionsList(
  ThemeData theme,
  AppLocalizations local,
  bool isArabic,
  String locale,
  List<VacationTransaction> transactions,
  bool loading,
) {
  return loading
      ? loadingWidget(theme)
      : SliverList.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return vacationTransactionTile(
              theme,
              local,
              locale,
              isArabic,
              transactions[index],
            );
          },
        );
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

Widget vacationTransactionTile(
  ThemeData theme,
  AppLocalizations local,
  String locale,
  bool isArabic,
  VacationTransaction item,
) {
  final absenceName = {
        "سنوي-راتب": local.annualLeave,
        "مأمورية": local.mission,
        "001": local.sickLeave,
        "009": local.compensatoryLeave,
        "006": local.umrahLeave,
        "008": local.bereavementLeave,
      }[item.absenceCode] ??
      local.annualLeave;

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
            _buildHeader(theme, absenceName, item, isArabic, local),
            const SizedBox(
              height: 8,
            ),
            _buildDateRow(item, local, locale),
          ],
        ),
      ),
    ),
  );
}

Row _buildHeader(
  ThemeData theme,
  String absenceName,
  VacationTransaction item,
  bool isArabic,
  AppLocalizations local,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        absenceName,
        style: TextStyle(
            color: theme.colorScheme.secondary, fontWeight: FontWeight.w600),
      ),
      Text(
        "${convertedToArabicNumber(
          double.parse(item.durationDays.toString()).round(),
          isArabic,
        )} ${local.days}",
        style: TextStyle(color: theme.colorScheme.primary),
      ),
    ],
  );
}

Widget _buildDateRow(
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
          text: DateFormat.yMMMd(locale).format(item.startDate),
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
          text: DateFormat.yMMMd(locale).format(item.endDate),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
