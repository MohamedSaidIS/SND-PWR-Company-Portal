import 'package:company_portal/utils/export_import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManagementKpiScreen extends StatefulWidget {
  const ManagementKpiScreen({super.key});

  @override
  State<ManagementKpiScreen> createState() => _ManagementKpiScreenState();
}

class _ManagementKpiScreenState extends State<ManagementKpiScreen> {
  String userEmail = "";
  late ThemeData theme;
  late AppLocalizations local;
  late ManagementKpiProvider provider;
  List<ManagementKpiSection> items = [];
  List<KPISheet> sheets = [];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var kpiProvider = context.read<ManagementKpiProvider>();
      final prefs = SharedPrefsHelper();
      userEmail = (await prefs.getUserData("UserEmail"))!;
      await kpiProvider.getSheets(/*"Sm@alsanidi.com.sa"*/ userEmail);
      //await kpiProvider.getKpiSheet(/*"Sm@alsanidi.com.sa"*/ userEmail, DateTime.now().year, 'Q1');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = context.theme;
    local = context.local;
    provider = context.watch<ManagementKpiProvider>();
    items = provider.managementKpiItems;
    sheets = provider.sheets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: local.kpis, backBtn: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            KpiEvaluationYears(userEmail: userEmail, kpiSheets: sheets),
            Expanded(
              child: provider.loadingSheet || provider.loading
                  ? AppNotifier.loadingWidget(theme)
                  :KpiEvaluationScreen(items: items),
            ),
          ],
        ),
      ),
    );
  }
}
