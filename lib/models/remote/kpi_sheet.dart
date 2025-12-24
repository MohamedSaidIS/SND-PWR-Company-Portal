import 'package:company_portal/utils/app_notifier.dart';

class KPISheet {
  final String id;
  final String name;
  final int year;
  final String? normalizedName;
  final String? quarter;

  KPISheet({
    required this.id,
    required this.name,
    required this.year,
    this.normalizedName,
    this.quarter,
  });

  factory KPISheet.fromJson(Map<String, dynamic> json) {
    final rawName = json['name'];

    final parsed = splitKpiName(rawName);
    AppNotifier.logWithScreen("KpiSheet", "ParsedValues: ${parsed.normalizedName} ${parsed.year} ${parsed.quarter}");

    return KPISheet(
        id: json['id'],
        name: json['name'],
        year: parsed.year,
        normalizedName: parsed.normalizedName,
        quarter: parsed.quarter
    );
  }
}

String normalizeSheetName(String name) {
  return name.toLowerCase();
}

({String normalizedName, int year, String quarter}) splitKpiName(
    String sheetName) {
  final regex = RegExp(r'^(.+?)[_\-\s]?(\d{4})[_\-\s]?(Q[1-4])$');

  final match = regex.firstMatch(sheetName);

  if (match == null) {
    throw FormatException('Invalid sheet name: $sheetName');
  }

  return (
    normalizedName: normalizeSheetName(match.group(1)!),
    year: int.parse(match.group(2)!),
    quarter: match.group(3)!
  );
}
