import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../utils/export_import.dart';

class DirectReportCardWidget extends StatefulWidget {
  const DirectReportCardWidget({
    super.key,
    required this.directReportItem,
  });

  final DirectReport directReportItem;

  @override
  State<DirectReportCardWidget> createState() => _DirectReportCardWidgetState();
}

class _DirectReportCardWidgetState extends State<DirectReportCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            20,
          ),
          color: Theme.of(context).bottomSheetTheme.backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.directReportItem.givenName != null &&
                    widget.directReportItem.surname != null,
                child: Text(
                  "${widget.directReportItem.givenName} ${widget.directReportItem.surname}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Visibility(
                visible: widget.directReportItem.jobTitle != null,
                child: Text(
                  "${widget.directReportItem.jobTitle}",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Visibility(
                visible: widget.directReportItem.mail != null,
                child: _buildInfoRow("${widget.directReportItem.mail}",
                    LineAwesomeIcons.mail_bulk_solid, context),
              ),
              Visibility(
                visible: widget.directReportItem.officeLocation != null,
                child: _buildInfoRow(
                  "${widget.directReportItem.officeLocation}",
                  LineAwesomeIcons.map_pin_solid,
                  context,
                ),
              ),
              Visibility(
                visible: widget.directReportItem.mobilePhone != null,
                child: _buildInfoRow("${widget.directReportItem.mobilePhone}",
                    LineAwesomeIcons.phone_solid, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildInfoRow(String title, IconData icon, BuildContext context) {
  return ListTile(
    leading: SizedBox(
      width: 20,
      height: 20,
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
    title: Text(
      title,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Theme.of(context).colorScheme.primary),
    ),
  );
}
