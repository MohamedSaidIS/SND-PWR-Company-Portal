import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';

class PreviousRequestItem extends StatefulWidget {
  final PreviousRequests item;
  const PreviousRequestItem({required this.item, super.key});

  @override
  State<PreviousRequestItem> createState() => _PreviousRequestItemState();
}

class _PreviousRequestItemState extends State<PreviousRequestItem> {
  late AppLocalizations local;
  late ThemeData theme;
  late String locale;
  String absenceName = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    local = context.local;
    theme = context.theme;
    locale = context.currentLocale();

    absenceName = {
      "سنوي-راتب": local.annualLeave,
      "مأمورية": local.mission,
      "001": local.sickLeave,
      "009": local.compensatoryLeave,
      "006": local.umrahLeave,
      "008": local.bereavementLeave,
      "إذن": local.permission
    }[widget.item.absenceCode] ??
        local.annualLeave;
  }
  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(
        absenceName,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 5.0, horizontal: 20),
        child: Transform.translate(
          offset: Offset(locale == "en" ? -20 : 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${local.from}: ${DatesHelper.formateDate(widget.item.startDateTime!, locale)}",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary),
              ),
              Text(
                "${local.to}: ${DatesHelper.formateDate(widget.item.endDateTime!, locale)}",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary),
              ),
            ],
          ),
        ),
      ),
      trailing: Transform.translate(
        offset: Offset(locale == "en" ? 10 : -10, 0),
        child: BadgeWidget(
            translatedTitle:
            getTranslatedApproval(widget.item.approved, local),
            color: getApprovalColor(widget.item.approved),
            icon: getApprovalIcon(widget.item.approved)),
      ),
    );
  }
}
