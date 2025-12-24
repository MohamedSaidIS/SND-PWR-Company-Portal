import 'dart:io';
import 'package:company_portal/models/remote/kpi_sheet_url.dart';
import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import '../models/remote/kpi_sheet.dart';
import '../models/remote/management_kpi_model.dart';
import '../utils/export_import.dart';

class ManagementKpiProvider extends ChangeNotifier {
  final GraphDioClient dioClient;

  ManagementKpiProvider({required this.dioClient});

  List<ManagementKpiSection> _managementKpiItems = [];
  KPISheetUrl? _sheetUrl;

  List<ManagementKpiSection> get managementKpiItems => _managementKpiItems;
  List<KPISheet> _sheets = [];
  bool _loading = false;
  String? _error;
  bool _loadingSheet = false;
  String? _errorSheet;

  KPISheetUrl? get sheetUrl => _sheetUrl;
  List<KPISheet> get sheets => _sheets;
  bool get loading => _loading;
  String? get error => _error;
  bool get loadingSheet => _loadingSheet;
  String? get errorSheet => _errorSheet;

  Future<void> getSheets(String email) async {
    _loadingSheet = true;
    _errorSheet = null;
    notifyListeners();

    try {
      final response = await dioClient.get(
          "https://graph.microsoft.com/v1.0/me/drive/items/01GFWH2DFIUDMQUP4L35EZEYOPLDJ2YI7F/workbook/worksheets");
      final normalizedEmail = normalizeSheetName(email);
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _sheets = await compute(
          (final data) => (data['value'] as List)
              .map((e) => KPISheet.fromJson(e as Map<String, dynamic>))
              .where((sheet) => sheet.normalizedName == normalizedEmail)
              .toList(),
          parsedResponse,
        );
        if (_sheets.isNotEmpty) {
          for (var sheet in _sheets) {
            AppNotifier.logWithScreen("Management KPI Provider",
                "KPI Sheets Fetching ${sheet.name} ${sheet.normalizedName}");
          }
        }
      } else {
        _error = 'Failed to load KPI Sheets';
        AppNotifier.logWithScreen("Management KPI Provider",
            "KPI Sheets Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Management KPI Provider", "KPI Sheets Exception: $_error");
    }
    _loadingSheet = false;
    notifyListeners();
  }

  Future<void> getSheetUrl() async {
    try {
      final response = await dioClient
          .get("https://graph.microsoft.com/v1.0/me/drive/root/children");

      if (response.statusCode == 200) {
        final parsedResponse = response.data;

        _sheetUrl = await compute(
          (data) {
            final List items = data['value'];

            final file = items.firstWhere(
              (item) =>
                  item is Map<String, dynamic> &&
                  item.containsKey('file') &&
                  item['name'] == "Employee KPIs - Sample.xlsx",
              orElse: () => throw Exception("KPI file not found"),
            );

            return KPISheetUrl(
              name: file['name'],
              url: file['@microsoft.graph.downloadUrl'],
            );
          },
          parsedResponse,
        );

        AppNotifier.logWithScreen(
          "Management KPI Provider",
          "KPI Sheet Url Success: ${_sheetUrl!.url} | ${_sheetUrl!.name}",
        );
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
        "Management KPI Provider",
        "KPI Sheet Url Exception: $_error",
      );
    }
  }

  Future<void> getKpiSheet(String email, int year, String? quarter) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await getSheetUrl();

      final response = await dioClient.dio.get(
        "${_sheetUrl!.url} ",
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        final Uint8List bytes = response.data!;
        final excel = Excel.decodeBytes(bytes);

        final List<List<dynamic>> csvRows = [];
        final tableName = quarter != null
            ? _sheets.firstWhere((item) =>
                item.normalizedName == normalizeSheetName(email) &&
                item.year == year &&
                item.quarter == quarter)
            : _sheets.firstWhere((item) =>
                item.normalizedName == normalizeSheetName(email) &&
                item.year == year);
        AppNotifier.logWithScreen("Management KPI Provider","TableName is: $tableName");

        final sheet = excel.tables[tableName.name]!;
        for (final row in sheet.rows) {
          csvRows.add(
            row.map((cell) => cell?.value ?? "").toList(),
          );
        }
        final csvData = const ListToCsvConverter().convert(csvRows);

        _managementKpiItems = await csvToManagementKpi(csvData);

        for (final section in _managementKpiItems) {
          AppNotifier.logWithScreen("Management KPI Provider",
              '${section.sectionTitle} (${section.secWeight})');
          for (final kpi in section.items) {
            AppNotifier.logWithScreen("Management KPI Provider",
                ' - ${kpi.title} => ${kpi.averageWeight}');
          }
        }
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Management KPI Provider", "Management KPI Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<File> excelToCsv(File excelFile) async {
    final bytes = excelFile.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    final sheet = excel.tables[excel.tables.keys.first]!;

    final rows = sheet.rows
        .map(
          (row) => row.map((cell) => cell?.value).toList(),
        )
        .toList();

    final csv = const ListToCsvConverter().convert(rows);

    final csvFile = File('${excelFile.path}.csv');
    return csvFile.writeAsString(csv);
  }

  Future<List<ManagementKpiSection>> csvToManagementKpi(String csvData) async {
    final rows = const CsvToListConverter().convert(csvData);

    final headers = rows.first;
    final dataRows = rows.skip(1);

    final Map<String, ManagementKpiSection> sections = {};
    String? currentSectionTitle;

    for (final row in dataRows) {
      final Map<String, dynamic> map = {};

      for (int i = 0; i < headers.length && i < row.length; i++) {
        final key = headers[i]?.toString().trim();
        if (key != null && key.isNotEmpty) {
          map[key] = row[i];
        }
      }

      final sectionTitle = map['KPI']?.toString().trim() ?? '';
      if (sectionTitle.isNotEmpty) {
        currentSectionTitle = sectionTitle;
        final sectionWeight =
            parseExcelNumber(map['Weight']?.toString() ?? '0');

        sections.putIfAbsent(
          currentSectionTitle,
          () => ManagementKpiSection(
            sectionTitle: currentSectionTitle ?? "",
            secWeight: sectionWeight,
            items: [],
          ),
        );
      }
      AppNotifier.logWithScreen("Management KPI Provider","CurrentSection: $currentSectionTitle | $sectionTitle");
      if (currentSectionTitle != null) {
        AppNotifier.logWithScreen("Management KPI Provider","CurrentSection Now: $currentSectionTitle | $sectionTitle");
        final kpiTitle = map['Factor']?.toString().trim() ?? '';
        if (kpiTitle.isNotEmpty) {
          sections[currentSectionTitle]!.items.add(
                KpiItem(
                  title: kpiTitle,
                  ratings: [
                    map['1'] == 'true',
                    map['2'] == 'true',
                    map['3'] == 'true',
                    map['4'] == 'true',
                    map['5'] == 'true',
                  ],
                  weight: 0,
                  score: 0,
                  averageWeight: 0,
                ),
              );
        }
      }
    }

    for (var section in sections.values) {
      final itemCount = section.items.length;
      if (itemCount == 0) continue;

      final int sectionW = section.secWeight;
      final double itemWeight = sectionW / itemCount;

      for (var item in section.items) {
        item.weight = double.parse(itemWeight.toString());
      }
      int value = 0;
      for (var item in section.items) {
        for (var i in item.ratings) {
          if (i == true) {
            value = item.ratings.indexOf(i) + 1;
          }
        }
        AppNotifier.logWithScreen("Management KPI Provider","Index before: $value");
        final double score = 1 / 5 * value;
        AppNotifier.logWithScreen("Management KPI Provider","Index after: $score");
        item.score = double.parse(score.toString());
        item.averageWeight =
            double.parse((score * itemWeight).toString());
      }
    }

    for (var i in sections.values.toList()) {
      AppNotifier.logWithScreen("Management KPI Provider","Section Values: ${i.sectionTitle} | ${i.secWeight}");
      for (var item in i.items) {
        AppNotifier.logWithScreen("Management KPI Provider",
            "Item List: ${item.title} | ${item.ratings} | Weight: ${item.weight} | Score: ${item.score} | AW: ${item.averageWeight}");
      }
    }
    return sections.values.toList();
  }

  int parseExcelNumber(String value) {
    final str = value.toString().trim();
    AppNotifier.logWithScreen("Management KPI Provider","Value is: $str");
    if (str.contains(RegExp(r'[\=\+\-\*/\$A-Za-z]'))) {
      AppNotifier.logWithScreen("Management KPI Provider","Value contains Strings $value");
      return 0;
    } else {
      AppNotifier.logWithScreen("Management KPI Provider","Parsed Value before: $str");
      final double? parsedDouble = double.tryParse(str);
      if (parsedDouble == null) {
        AppNotifier.logWithScreen("Management KPI Provider","Cannot parse value: $str");
        return 0;
      }
      final int parsedValue = (parsedDouble * 100).toInt();
      AppNotifier.logWithScreen("Management KPI Provider","Parsed Value is: $parsedValue");
      return parsedValue;
    }
  }

  String normalizeSheetName(String name) {
    return name.toLowerCase();
  }
}
